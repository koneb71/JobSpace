# project/config.py

import os
import paypalrestsdk

basedir = os.path.abspath(os.path.dirname(__file__))


class BaseConfig(object):
    DEBUG = True
    UPLOAD_FOLDER = basedir
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
    BCRYPT_LOG_ROUNDS = 13
