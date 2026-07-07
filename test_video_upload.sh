#!/bin/bash
TOKEN=$(bash /opt/test_login.sh 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['token'])" 2>/dev/null)
echo "test data" > /tmp/vtest.mp4
curl -s -X POST 'http://localhost:8080/api/stock/vehicles/1/videos/upload' -H "Authorization: Bearer $TOKEN" -F 'file=@/tmp/vtest.mp4' -F 'title=test'
