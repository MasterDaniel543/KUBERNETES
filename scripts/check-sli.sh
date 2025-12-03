#!/usr/bin/env bash
set -euo pipefail
NAMESPACE=${1:?}
WINDOW=${2:?}
LATENCY=${3:?}
ERROR=${4:?}
AVAIL=${5:?}
LAT=$(curl -s "$PROM_URL/api/v1/query?query=histogram_quantile(0.95,sum(rate(http_request_duration_seconds_bucket{namespace='$NAMESPACE'}[$WINDOW])) by (le))" | jq -r .data.result[0].value[1])
ERR=$(curl -s "$PROM_URL/api/v1/query?query=sum(rate(http_requests_errors_total{namespace='$NAMESPACE'}[$WINDOW]))/sum(rate(http_requests_total{namespace='$NAMESPACE'}[$WINDOW]))" | jq -r .data.result[0].value[1])
AVA=$(curl -s "$PROM_URL/api/v1/query?query=avg(up{namespace='$NAMESPACE'})" | jq -r .data.result[0].value[1])
test $(echo "$LAT < $LATENCY" | bc -l) -eq 1
test $(echo "$ERR < $ERROR" | bc -l) -eq 1
test $(echo "$AVA >= $AVAIL" | bc -l) -eq 1
