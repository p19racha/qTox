# qTox Web Frontend

Modern browser-based UI for qTox messaging.

## Quick Start

1. **Start the backend:**
   ```bash
   cd web-backend
   python3 server.py
   ```

2. **Open frontend:**
   ```bash
   # Option 1: Use Python's built-in server
   cd web-frontend
   python3 -m http.server 8000
   # Then open http://localhost:8000

   # Option 2: Open index.html directly in browser
   firefox index.html
   # or
   google-chrome index.html
   ```

## Features

- ✅ Modern dark theme (Telegram-inspired)
- ✅ Friend list with online status
- ✅ Real-time chat interface
- ✅ Message history
- ✅ Add friends
- ✅ Responsive design

## Architecture

```
┌─────────────────┐      HTTP/WebSocket      ┌──────────────────┐
│   Browser UI    │ ◄──────────────────────► │  Python Backend  │
│  (Static HTML)  │     localhost:8080       │  (System Service)│
└─────────────────┘                          └──────────────────┘
                                                     │
                                                     ▼
                                              ┌──────────────┐
                                              │  Tox Core    │
                                              │  (Protocol)  │
                                              └──────────────┘
```

## Technology Stack

- **Frontend**: Vanilla JavaScript (no framework needed)
- **Styling**: Pure CSS with modern design
- **API Communication**: Fetch API
- **Real-time**: WebSocket (to be added)

## Browser Support

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Customization

Edit `index.html` to customize:
- Colors (search for `#0E1621`, `#2AABEE`)
- Layout dimensions
- API endpoint (`API_BASE` constant)

## Next Steps

- [ ] Add WebSocket for real-time updates
- [ ] Implement file transfer UI
- [ ] Add group chat support
- [ ] Voice/video call interface
- [ ] Settings panel
- [ ] Notifications
- [ ] PWA support (offline mode)

## Development

No build process needed! Just edit `index.html` and refresh.

For debugging:
```javascript
// Add to browser console
localStorage.setItem('debug', 'true');
```

## Security

- Always use HTTPS in production
- Implement Content Security Policy
- Add authentication tokens
- Validate all user input
