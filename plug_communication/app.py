from flask import Flask, jsonify
from tplink_smartplug import SmartPlug
import os
app = Flask(__name__)
plug = SmartPlug(os.getenv('PLUG_IP'))

@app.route("/is_on", methods=['GET'])
def is_on():
    return jsonify({'is_on': plug.is_on})

@app.route("/turn_on", methods=['GET'])
def turn_on():
    plug.turn_on()
    return jsonify({'is_on': plug.is_on})

@app.route("/turn_off", methods=['GET'])
def turn_off():
    plug.turn_off()
    return jsonify({'is_on': plug.is_on})