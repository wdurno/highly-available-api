import random
import string
from flask import Flask
app = Flask(__name__)

letters = string.ascii_lowercase
api_id =  ''.join(random.choice(letters) for i in range(10))

@app.route('/')
def hello():
    return api_id


@app.route('/healthy')
def health():
    return "200", 200

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
