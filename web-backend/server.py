#!/usr/bin/env python3
"""
qTox Web Backend - Minimal HTTP API Server
Runs as a local service, provides REST API for browser frontend
"""

import json
import http.server
import socketserver
from urllib.parse import urlparse, parse_qs
from datetime import datetime
import threading
import time

PORT = 8080

# In-memory data (will be replaced with actual Tox integration)
app_state = {
    "status": "online",
    "username": "User",
    "status_message": "Using qTox Web",
    "tox_id": "76518406F4DF9A9DCFE181E0B164346F6A6D92C4F7E8B7A3D5C2E1F9A8B7C6D5",
    "avatar": None,
    "friends": [
        {
            "id": "1",
            "name": "Alice",
            "status": "online",
            "last_message": "Hey there!",
            "unread": 2
        },
        {
            "id": "2", 
            "name": "Bob",
            "status": "away",
            "last_message": "See you later",
            "unread": 0
        }
    ],
    "messages": {
        "1": [
            {"from": "Alice", "text": "Hey there!", "time": "12:30 PM"},
            {"from": "Me", "text": "Hi Alice!", "time": "12:31 PM"}
        ]
    }
}

class qToxAPIHandler(http.server.SimpleHTTPRequestHandler):
    """Handle API requests for qTox web frontend"""
    
    def do_OPTIONS(self):
        """Handle CORS preflight"""
        self.send_response(200)
        self.send_cors_headers()
        self.end_headers()
    
    def send_cors_headers(self):
        """Enable CORS for local browser access"""
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
    
    def do_GET(self):
        """Handle GET requests"""
        parsed = urlparse(self.path)
        
        if parsed.path == '/api/status':
            self.send_json_response({
                "status": app_state["status"],
                "username": app_state["username"],
                "status_message": app_state["status_message"],
                "timestamp": datetime.now().isoformat()
            })
        
        elif parsed.path == '/api/friends':
            self.send_json_response({
                "friends": app_state["friends"]
            })
        
        elif parsed.path.startswith('/api/messages/'):
            friend_id = parsed.path.split('/')[-1]
            messages = app_state["messages"].get(friend_id, [])
            self.send_json_response({
                "friend_id": friend_id,
                "messages": messages
            })
        
        elif parsed.path == '/api/health':
            self.send_json_response({
                "status": "healthy",
                "version": "1.0.0",
                "uptime": time.time()
            })
        
        elif parsed.path == '/api/profile':
            self.send_json_response({
                "username": app_state["username"],
                "status_message": app_state["status_message"],
                "tox_id": app_state["tox_id"],
                "avatar": app_state.get("avatar"),
                "status": app_state["status"]
            })
        
        else:
            self.send_error(404, "Endpoint not found")
    
    def do_POST(self):
        """Handle POST requests"""
        parsed = urlparse(self.path)
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length).decode('utf-8')
        
        try:
            data = json.loads(body) if body else {}
        except json.JSONDecodeError:
            self.send_error(400, "Invalid JSON")
            return
        
        if parsed.path == '/api/friends':
            # Add friend
            new_friend = {
                "id": str(len(app_state["friends"]) + 1),
                "name": data.get("name", "Unknown"),
                "status": "offline",
                "last_message": "",
                "unread": 0
            }
            app_state["friends"].append(new_friend)
            self.send_json_response({"success": True, "friend": new_friend}, status=201)
        
        elif parsed.path == '/api/messages':
            # Send message
            friend_id = data.get("friend_id")
            text = data.get("text")
            
            if not friend_id or not text:
                self.send_error(400, "Missing friend_id or text")
                return
            
            if friend_id not in app_state["messages"]:
                app_state["messages"][friend_id] = []
            
            message = {
                "from": "Me",
                "text": text,
                "time": datetime.now().strftime("%I:%M %p")
            }
            app_state["messages"][friend_id].append(message)
            
            self.send_json_response({"success": True, "message": message}, status=201)
        
        elif parsed.path == '/api/status':
            # Update status
            if "status" in data:
                app_state["status"] = data["status"]
            if "status_message" in data:
                app_state["status_message"] = data["status_message"]
            
            self.send_json_response({"success": True, "status": app_state["status"]})
        
        elif parsed.path == '/api/profile':
            # Update profile
            if "username" in data:
                app_state["username"] = data["username"]
            if "status_message" in data:
                app_state["status_message"] = data["status_message"]
            if "status" in data:
                app_state["status"] = data["status"]
            
            self.send_json_response({
                "success": True,
                "profile": {
                    "username": app_state["username"],
                    "status_message": app_state["status_message"],
                    "status": app_state["status"]
                }
            })
        
        elif parsed.path == '/api/avatar':
            # Handle avatar upload (simplified - in production use proper file handling)
            if "avatar_data" in data:
                app_state["avatar"] = data["avatar_data"]
                self.send_json_response({"success": True, "message": "Avatar updated"})
            else:
                self.send_error(400, "Missing avatar_data")
        
        else:
            self.send_error(404, "Endpoint not found")
    
    def send_json_response(self, data, status=200):
        """Send JSON response with CORS headers"""
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_cors_headers()
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))
    
    def log_message(self, format, *args):
        """Custom log format"""
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {format % args}")


def run_server():
    """Start the HTTP server"""
    with socketserver.TCPServer(("127.0.0.1", PORT), qToxAPIHandler) as httpd:
        print(f"qTox Web Backend running on http://127.0.0.1:{PORT}")
        print(f"API endpoints:")
        print(f"  GET  /api/status       - Get current status")
        print(f"  GET  /api/friends      - List all friends")
        print(f"  GET  /api/messages/:id - Get messages for friend")
        print(f"  GET  /api/profile      - Get user profile")
        print(f"  POST /api/friends      - Add new friend")
        print(f"  POST /api/messages     - Send message")
        print(f"  POST /api/status       - Update status")
        print(f"  POST /api/profile      - Update profile")
        print(f"  POST /api/avatar       - Upload avatar")
        print(f"\nPress Ctrl+C to stop")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down server...")


if __name__ == "__main__":
    run_server()
