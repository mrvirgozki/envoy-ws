#!/bin/sh
set -e

echo "✅ Sinisimulan ang Xray..."
/usr/local/bin/xray run -c /etc/xray.json &

sleep 2

echo "✅ Sinisimulan ang Envoy Proxy..."
/usr/local/bin/envoy -c /etc/envoy/envoy.yaml --service-cluster proxy &

sleep 2

echo "✅ Sinisimulan ang Web Panel (index.html)..."
# I-serve ang index.html gamit ang Python server sa port 8080
python3 -m http.server 8080 --directory /var/www/html
