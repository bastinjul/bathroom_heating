from glob import glob
from flask import Flask, jsonify
app = Flask(__name__)

is_plug_on = False

@app.route("/is_on", methods=['GET'])
def is_on():
    return jsonify({'is_on': is_plug_on})

@app.route("/turn_on", methods=['GET'])
def turn_on():
    global is_plug_on
    is_plug_on = True
    return jsonify({'is_on': is_plug_on})

@app.route("/turn_off", methods=['GET'])
def turn_off():
    global is_plug_on
    is_plug_on = False
    return jsonify({'is_on': is_plug_on})