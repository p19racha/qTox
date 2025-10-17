# qTox Web Backend

Local HTTP API server for qTox web frontend.

## Quick Start

```bash
# Start the backend
python3 server.py
```

The server will run on `http://127.0.0.1:8080`

## API Endpoints

### GET /api/status
Get current user status
```json
{
  "status": "online",
  "username": "User",
  "status_message": "Using qTox Web",
  "timestamp": "2025-10-17T06:55:07.540000"
}
```

### GET /api/friends
List all friends
```json
{
  "friends": [
    {
      "id": "1",
      "name": "Alice",
      "status": "online",
      "last_message": "Hey there!",
      "unread": 2
    }
  ]
}
```

### GET /api/messages/:id
Get messages for a friend
```json
{
  "friend_id": "1",
  "messages": [
    {
      "from": "Alice",
      "text": "Hey there!",
      "time": "12:30 PM"
    }
  ]
}
```

### POST /api/friends
Add a new friend
```json
{
  "name": "Bob"
}
```

### POST /api/messages
Send a message
```json
{
  "friend_id": "1",
  "text": "Hello!"
}
```

### POST /api/status
Update user status
```json
{
  "status": "away",
  "status_message": "Be right back"
}
```

## Run as System Service

Create `/etc/systemd/system/qtox-backend.service`:

```ini
[Unit]
Description=qTox Web Backend Service
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/qTox/web-backend
ExecStart=/usr/bin/python3 /home/YOUR_USERNAME/qTox/web-backend/server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable qtox-backend
sudo systemctl start qtox-backend
sudo systemctl status qtox-backend
```

## Next Steps

1. **Integrate Tox Core**: Replace in-memory data with actual Tox protocol
2. **Add Authentication**: Secure the API with token-based auth
3. **WebSocket Support**: Add real-time message delivery
4. **Persistence**: Store data in SQLite/PostgreSQL
5. **File Transfers**: Handle file uploads/downloads
6. **Encryption**: End-to-end encryption for messages

## Development

The current implementation uses in-memory storage for demonstration. To integrate with actual Tox:

1. Use Python Tox bindings (pytox or toxcore)
2. Handle Tox callbacks in a separate thread
3. Maintain persistent WebSocket connections for real-time updates
4. Store chat history in database

## Security Notes

- Currently runs on localhost only (127.0.0.1)
- No authentication implemented yet
- CORS enabled for local development
- **DO NOT expose to network without proper security**
