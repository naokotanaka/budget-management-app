#\!/bin/bash

# Backend auto-restart script
LOG_FILE="/root/nagaiku-budget/logs/backend.log"
BACKEND_DIR="/root/nagaiku-budget/backend"

while true; do
    echo "$(date): Starting backend server..." >> $LOG_FILE
    
    cd $BACKEND_DIR
    source venv/bin/activate
    
    # Start uvicorn with auto-reload
    uvicorn main:app --host 0.0.0.0 --port 8000 --reload >> $LOG_FILE 2>&1
    
    echo "$(date): Backend server stopped. Restarting in 5 seconds..." >> $LOG_FILE
    sleep 5
done
EOF < /dev/null
