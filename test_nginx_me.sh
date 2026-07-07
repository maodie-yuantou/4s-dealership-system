#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "--- Direct to 8080 ---"
curl -s http://localhost:8080/api/auth/me -H "Authorization: Bearer $TOKEN" | head -c 50
echo ""
echo "--- Through Nginx 80 ---"
curl -s http://localhost/api/auth/me -H "Authorization: Bearer $TOKEN" | head -c 50
