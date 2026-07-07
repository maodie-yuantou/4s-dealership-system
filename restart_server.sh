#!/bin/bash
PID=$(ps aux | grep cardealership | grep -v grep | awk '{print $2}')
if [ -n "$PID" ]; then
  kill $PID
  echo "Killed PID $PID"
  sleep 3
fi
cd /opt/4s-dealership-system
nohup java -Xmx384m -jar cardealership-1.0.0.jar --spring.config.location=file:./application.yml > app.log 2>&1 &
echo "Started new process"
sleep 25
grep Started app.log | tail -1
