from flask import jsonify
import uuid


def get_uuid():
    return jsonify(uuid=str(uuid.uuid4()))


def get_home():
    return jsonify(message="Hello, World!")


def get_healthz():
    return jsonify(status="OK")
