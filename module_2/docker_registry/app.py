from flask import Flask, jsonify
from controller import get_uuid, get_home, get_healthz

app = Flask(__name__)

app.add_url_rule('/', 'home', get_home)
app.add_url_rule('/uuid', 'uuid', get_uuid)
app.add_url_rule('/healthz', 'healthz', get_healthz)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081)
