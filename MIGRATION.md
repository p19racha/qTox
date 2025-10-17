# qTox Web Architecture - Migration Plan

## Overview

You now have a **working web-based qTox prototype**:
- ✅ **Backend**: Python HTTP API running on localhost:8080
- ✅ **Frontend**: Static HTML/JS running on localhost:3000
- ✅ **Communication**: REST API with CORS

## Current Status

### What Works Now
1. Backend API serving status, friends, messages
2. Modern dark-themed UI in browser
3. Friend list display
4. Message viewing
5. Adding friends
6. Sending messages

### What's Missing
- Actual Tox protocol integration (currently using mock data)
- Real-time message delivery (need WebSocket)
- File transfers
- Voice/video calls
- End-to-end encryption
- User authentication
- Persistent storage

## Integration Roadmap

### Phase 1: Tox Core Integration (Week 1-2)
```python
# Replace mock data with actual Tox
from toxcore import Tox

class ToxBackend:
    def __init__(self):
        self.tox = Tox()
        self.tox.callback_friend_message(self.on_friend_message)
        
    def on_friend_message(self, friend_number, message_type, message):
        # Broadcast via WebSocket to frontend
        pass
```

**Libraries:**
- `pytox` or `PyTox` for Python bindings
- `toxcore-c` as dependency

**Tasks:**
- [ ] Install Tox C library
- [ ] Add Python Tox bindings
- [ ] Implement Tox callbacks
- [ ] Replace mock friends with real Tox friends
- [ ] Handle Tox ID resolution

### Phase 2: Real-time Updates (Week 2-3)
```python
# Add WebSocket support
from websockets import serve

async def websocket_handler(websocket):
    # Push real-time updates
    await websocket.send(json.dumps({
        "type": "new_message",
        "friend_id": "1",
        "message": {...}
    }))
```

**Libraries:**
- `websockets` for Python
- Update frontend to use WebSocket API

**Tasks:**
- [ ] Implement WebSocket server
- [ ] Add connection management
- [ ] Push new messages to browser
- [ ] Handle friend status changes
- [ ] Reconnection logic

### Phase 3: Persistence (Week 3-4)
```python
# Store chat history
import sqlite3

class Database:
    def store_message(self, friend_id, message, timestamp):
        self.conn.execute(
            "INSERT INTO messages VALUES (?, ?, ?)",
            (friend_id, message, timestamp)
        )
```

**Database:**
- SQLite for local storage (simple)
- OR PostgreSQL for advanced features

**Tasks:**
- [ ] Design database schema
- [ ] Store chat history
- [ ] Store friend list
- [ ] Store user settings
- [ ] Migration from old qTox database

### Phase 4: Security (Week 4-5)
```python
# Add authentication
import secrets

class AuthManager:
    def generate_token(self):
        return secrets.token_urlsafe(32)
    
    def verify_token(self, token):
        # Check if valid
        pass
```

**Security Measures:**
- Token-based authentication
- HTTPS/TLS encryption
- Content Security Policy
- Rate limiting

**Tasks:**
- [ ] Implement auth tokens
- [ ] Add TLS certificate
- [ ] Secure WebSocket (WSS)
- [ ] Input validation
- [ ] XSS protection

### Phase 5: Advanced Features (Week 5-8)
- [ ] File transfer API
- [ ] Voice/video call signaling
- [ ] Group chat support
- [ ] Typing indicators
- [ ] Read receipts
- [ ] Desktop notifications
- [ ] PWA (offline support)

## System Service Setup

### 1. Backend Service

Create `/etc/systemd/system/qtox-backend.service`:
```ini
[Unit]
Description=qTox Web Backend
After=network.target

[Service]
Type=simple
User=racha
WorkingDirectory=/home/racha/qTox/web-backend
ExecStart=/usr/bin/python3 server.py
Restart=always
RestartSec=10
Environment="PYTHONUNBUFFERED=1"

[Install]
WantedBy=multi-user.target
```

**Enable:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable qtox-backend
sudo systemctl start qtox-backend
```

### 2. Nginx Frontend (Optional)

Create `/etc/nginx/sites-available/qtox`:
```nginx
server {
    listen 80;
    server_name localhost;
    
    root /home/racha/qTox/web-frontend;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## Migration from Qt UI

### Data Migration
```python
# Migrate from old SQLCipher database
import sqlite3

def migrate_from_old_qtox():
    old_db = sqlite3.connect('~/.config/tox/test.db')
    new_db = sqlite3.connect('web-backend/qtox.db')
    
    # Copy friends
    friends = old_db.execute("SELECT * FROM friends").fetchall()
    for friend in friends:
        new_db.execute("INSERT INTO friends VALUES (?)", friend)
    
    # Copy messages
    messages = old_db.execute("SELECT * FROM history").fetchall()
    for msg in messages:
        new_db.execute("INSERT INTO messages VALUES (?)", msg)
```

### Configuration Migration
```python
# Read old settings
import configparser

config = configparser.ConfigParser()
config.read('~/.config/tox/qtox.ini')

username = config.get('General', 'username')
status = config.get('General', 'status')
```

## Performance Considerations

### Backend Optimization
- Use `asyncio` for concurrent requests
- Add caching for friend list
- Batch database writes
- Use connection pooling

### Frontend Optimization
- Lazy load messages (pagination)
- Virtual scrolling for long chats
- Service Worker for offline
- Local storage for caching

## Testing Strategy

1. **Unit Tests**: Test API endpoints
   ```bash
   python3 -m pytest tests/
   ```

2. **Integration Tests**: Test Tox integration
   ```bash
   python3 -m pytest tests/integration/
   ```

3. **E2E Tests**: Test browser UI
   ```bash
   playwright test
   ```

## Deployment Checklist

- [ ] Backend running as systemd service
- [ ] Frontend served via nginx
- [ ] HTTPS enabled
- [ ] Database backups configured
- [ ] Logging configured
- [ ] Monitoring setup (optional: Prometheus)
- [ ] Firewall rules (only localhost:8080)

## Resources

- **Tox Protocol**: https://toktok.ltd/spec.html
- **Python Tox**: https://github.com/toxygen-project/toxygen
- **WebSocket API**: https://websockets.readthedocs.io/
- **REST Best Practices**: https://restfulapi.net/

## Comparison: Qt vs Web

| Feature | Qt Desktop | Web-Based |
|---------|-----------|-----------|
| Installation | Package/Binary | Just open browser |
| Updates | Manual | Instant |
| Cross-platform | Compile per OS | Works everywhere |
| Performance | Native | Good (JS optimized) |
| Offline | Full | Limited (PWA) |
| UI Framework | Qt Widgets/QML | HTML/CSS/JS |
| System Integration | Deep | Limited |

## Next Immediate Steps

1. **Test the current prototype**:
   ```bash
   # Backend already running on :8080
   # Frontend: Open http://localhost:3000 in browser
   ```

2. **Add a test message**:
   ```bash
   curl -X POST http://127.0.0.1:8080/api/messages \
     -H "Content-Type: application/json" \
     -d '{"friend_id": "1", "text": "Hello from API!"}'
   ```

3. **Plan Tox integration**:
   - Research Python Tox libraries
   - Design callback architecture
   - Plan WebSocket integration

**Current prototype is functional and ready for Tox integration!** 🎉
