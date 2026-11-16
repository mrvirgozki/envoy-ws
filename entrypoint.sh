#!/bin/sh
set -e

echo "✅ Sinisimulan ang Xray..."
/usr/local/bin/xray run -c /etc/xray.json &

sleep 2

echo "✅ Sinisimulan ang Envoy Proxy..."
exec /usr/local/bin/envoy -c /etc/envoy/envoy.yaml --service-cluster proxy
