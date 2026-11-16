FROM teddysun/xray:latest AS xray-bin
FROM envoyproxy/envoy:v1.28-latest

# Mag-install ng Nginx para sa secure at enterprise-grade web serving / reverse proxy
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY --from=xray-bin /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray.json
COPY envoy.yaml /etc/envoy/envoy.yaml
COPY index.html /var/www/html/index.html
COPY entrypoint.sh /entrypoint.sh

# Nginx configuration para i-serve ang index.html at i-forward ang websocket paths kay Envoy (port 10004)
RUN echo 'server { \
    listen 8080; \
    location / { \
        root /var/www/html; \
        index index.html; \
    } \
    location ~ ^/(vless-ws|vmess-ws|trojan-ws|ss-ws) { \
        proxy_pass http://127.0.0.1:10004; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "upgrade"; \
        proxy_set_header Host $host; \
    } \
}' > /etc/nginx/sites-available/default

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
