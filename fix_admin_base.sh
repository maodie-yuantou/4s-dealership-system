#!/bin/bash
sed -i 's|<head>|<head><base href="/admin/">|' /opt/frontend/admin/index.html
cat /opt/frontend/admin/index.html
docker restart 4s-nginx
echo "done"
