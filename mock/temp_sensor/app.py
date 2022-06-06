from flask import Flask, jsonify
import random
app = Flask(__name__)

@app.route("/temp", methods=['GET'])
def is_on():
    return jsonify({'sensor': 'temp', 'data': random.uniform(15.0, 20.0)})