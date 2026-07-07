#!/bin/bash
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d '{"username":"maodie","password":"123456"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])")
echo "Token ok"

echo "test" > /tmp/test_avatar.txt
curl -s -X POST http://localhost:8080/api/auth/avatar -H "Authorization: Bearer $TOKEN" -F "file=@/tmp/test_avatar.txt" | head -c 100
