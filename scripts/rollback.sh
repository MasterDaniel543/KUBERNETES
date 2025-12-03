#!/usr/bin/env bash
set -euo pipefail
kubectl rollout undo deployment/app -n prod
kubectl annotate deployment/app app.example/rollback-cause="sli_failed" -n prod --overwrite
