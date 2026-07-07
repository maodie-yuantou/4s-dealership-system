#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "--- KPI ---"
curl -s http://localhost:8080/api/report/kpi -H "Authorization: Bearer $TOKEN"
