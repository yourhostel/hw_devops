# python/app.py

from flask import Flask, render_template_string

app = Flask(__name__)


@app.route('/')
def index():
    with open('index.html', 'r') as file:
        html_content = file.read()
    return render_template_string(html_content)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
