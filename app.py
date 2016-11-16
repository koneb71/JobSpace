from flask import Flask, request, jsonify, g
from flask_httpauth import HTTPTokenAuth
from itsdangerous import TimedJSONWebSignatureSerializer as JWT
from werkzeug.utils import secure_filename

from config import BaseConfig
import sys, os, flask, json
from functions import is_valid_email
from models import DBconn, call_stored_procedure
from flask.ext.cors import CORS

# config
app = Flask(__name__)
app.config.from_object(BaseConfig)
app.config['SECRET_KEY'] = 'EERwyDyEfWWO4NLFAqs8m4UZxKhZvMOsgeKqi1G0jgyREwE4LuZLC_g677uCJXcHUP7013FU65yAGoHM'
UPLOAD_FOLDER = 'images/'

jwt = JWT(app.config['SECRET_KEY'], expires_in=3600)
basedir = os.path.abspath(os.path.dirname(UPLOAD_FOLDER))

auth = HTTPTokenAuth('Bearer')
CORS(app, supports_credentials=True)


@auth.verify_token
def verify_token(token):
    g.user = None
    try:
        data = jwt.loads(token)
    except:
        return False
    if 'user' in data:
        g.user = data['user']
        g.id = data['id']
        return True
    return False


# For a given file, return whether it's an allowed type or not
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in app.config.ALLOWED_EXTENSIONS



"""routes"""

@app.route('/api/v1.0/user/login/', methods=['POST'])
def login():
    data = request.json
    if is_valid_email(data['email']):
        status = False
        return jsonify({'status': status, 'message': 'Invalid Email address'})

    res = call_stored_procedure("user_login", (data['email'], data['password']))

    if res[0][0] == 'ERROR':
        status = False
        return jsonify({'status': status, 'message': 'error'})
    else:
        status = True
        token = jwt.dumps({'user': data['email'], 'id': res})
        return jsonify({'status': status, 'token': token, 'message': 'success'})


@app.route('/api/v1.0/user/create', methods=['POST'])
def new_user():
    jsn = json.loads(request.data)

    if is_valid_email(jsn['email']):
        return jsonify({'status': 'error', 'message': 'Error'})

    res = call_stored_procedure("new_user", (
        jsn['fname'],
        jsn['mname'],
        jsn['lname'],
        jsn['email'],
        jsn['personnel_password'],
        jsn['hotel_id']
    ), True)

    if 'Error' in res[0][0]:
        return jsonify({'status': 'ok', 'message': res[0][0]})

    return jsonify({'status': 'ok', 'message': res[0][0]})


@app.route('/api/v1.0/upload/image/', methods=['POST'])
@auth.login_required
def upload_file():
    uploaded_files = request.files.getlist("file[]")
    filenames = []
    for file in uploaded_files:
        # Check if the file is one of the allowed types/extensions
        if file and allowed_file(file.filename):
            # Make the filename safe, remove unsupported chars
            filename = secure_filename(file.filename)
            # Move the file form the temporal folder to the upload
            # folder we setup
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            # Save the filename into a list, we'll use it later
        else:
            return jsonify({'status': 'error'})
        hotel_id = g.id[0][0]
        res = call_stored_procedure('newimage', (filename, int(hotel_id)), True)
    return jsonify({'status': 'OK'})


@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Bearer'] = True
    resp.headers['Bearer'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging
    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp
