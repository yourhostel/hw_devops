# homework-20240623/docker/web_server.py

from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def get_hostname():
    hostname = socket.gethostname()
    return f"Hostname/Pod: {hostname}"

@app.route('/readiness')
def readiness():
    return "Ready", 200

@app.route('/liveness')
def liveness():
    return "Alive", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

