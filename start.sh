#!/bin/bash
set -e

export FLASK_DEBUG=0
export DOMINIOS_PERMITIDOS="${DOMINIOS_PERMITIDOS:-gmail.com,outlook.com,yahoo.com}"

echo "=== Vulcanizadora IA - Production ==="
echo "Workers: 4 | Port: 8000"
echo "Domains: $DOMINIOS_PERMITIDOS"
echo ""

exec gunicorn --workers 4 \
              --worker-class sync \
              --bind 0.0.0.0:8000 \
              --timeout 60 \
              --max-requests 1000 \
              --max-requests-jitter 100 \
              --access-logfile - \
              --error-logfile - \
              --log-level info \
              app:app
