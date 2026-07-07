#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "Token claims:"
echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null | python3 -m json.tool
echo "--- Testing system/users ---"
curl -s http://localhost:8080/api/system/users?page=1 -H "Authorization: Bearer $TOKEN"
