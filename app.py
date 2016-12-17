from flask import Flask, request, jsonify, g
from flask import render_template
from flask_httpauth import HTTPTokenAuth
from itsdangerous import TimedJSONWebSignatureSerializer as JWT
from werkzeug.utils import secure_filename

from config import BaseConfig
import sys, os, flask, json
from processors import is_valid_email
from models import DBconn, call_stored_procedure
from flask_cors import CORS

# config
flask_app = Flask(__name__)
flask_app.config.from_object(BaseConfig)
flask_app.config['SECRET_KEY'] = 'EERwyDyEfWWO4NLFAqs8m4UZxKhZvMOsgeKqi1G0jgyREwE4LuZLC_g677uCJXcHUP7013FU65yAGoHM'
UPLOAD_FOLDER = 'images/'

jwt = JWT(flask_app.config['SECRET_KEY'], expires_in=3600)
basedir = os.path.abspath(os.path.dirname(UPLOAD_FOLDER))

auth = HTTPTokenAuth('Bearer')
CORS(flask_app, supports_credentials=True)

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
           filename.rsplit('.', 1)[1] in flask_app.config.ALLOWED_EXTENSIONS


"""routes"""


@flask_app.route('/api/v1.0/user/login/', methods=['POST'])
def login():
    data = json.loads(request.data)

    if is_valid_email(data['email']):
        status = False
        return jsonify({'status': status, 'message': 'Invalid Email address'})

    res = call_stored_procedure("loginauth", (''.join(data['email']), ''.join(data['password'])))

    if res[0][0] == 'ERROR':
        status = False
        return jsonify({'status': status, 'message': res[0][0]})
    else:
        status = True
        token = jwt.dumps({'user': data['email'], 'id': res})
        return jsonify({'status': status, 'token': token, 'message': res[0][0]})


@flask_app.route('/api/v1.0/user/create', methods=['POST'])
def new_user():
    data = json.loads(request.data)

    if is_valid_email(data['email']):
        return jsonify({'status': 'error', 'message': 'Error'})

    res = call_stored_procedure("newuser", (
        data['email'], data['fname'], data['mname'], data['lname'], data['password'], data['birthday'], data['gender'],
        int(data['acc_level']), data['title'], data['status']
    ), False)

    if 'Error' in res[0][0]:
        return jsonify({'status': 'ok', 'message': res[0][0]})

    return jsonify({'status': 'ok', 'message': res[0][0]})


@flask_app.route('/api/v1.0/question/create', methods=['POST'])
def new_question():
    data = json.loads(request.data)

    res = call_stored_procedure("newquestion", (
            data['name'], int(data['one_way_interview_id'])
    ), False)

    if 'Error' in res[0][0]:
        return jsonify({'status': 'ok', 'message': res[0][0]})

    return jsonify({'status': 'ok', 'message': 'Question Added'})


@flask_app.route('/api/v1.0/user/<id>/', methods=['GET'])
def getuser(id):

    res = call_stored_procedure("get_user", [int(id)])

    if not res:
        return jsonify({'status': 'Error', 'message': 'Results Not Found'}), 404

    rec = res[0]
    print rec
    data = {'id': str(id), 'email': rec[0], 'fname': rec[1], 'mname': rec[2], 'lname': rec[3],
            'birthday': rec[4], 'gender': rec[5], 'acc_level': str(rec[6]), 'title': rec[7], 'status': rec[8]}

    return jsonify(data)


@flask_app.route('/api/v1.0/upload/video/', methods=['POST'])
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
            file.save(os.path.join(flask_app.config['UPLOAD_FOLDER'], filename))
            # Save the filename into a list, we'll use it later
        else:
            return jsonify({'status': 'error'})
        hotel_id = g.id[0][0]
        res = call_stored_procedure('newimage', (filename, int(hotel_id)), True)
    return jsonify({'status': 'OK'})


@flask_app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Bearer'] = True
    resp.headers['Bearer'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging
    if flask_app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp
