from sqlalchemy import create_engine
import os
import sys


connection = 'local' #or change it to local if you're running on local machine

if connection == 'OPENSHIFT_POSTGRESQL_DB_URL':
    class DBconn:
        def __init__(self):
            engine = create_engine("postgresql://postgres:iReserve5432@localhost:5432/iReserve3")
            self.conn = engine.connect()
            self.trans = self.conn.begin()


        def getcursor(self):
            cursor = self.conn.connection.cursor()
            return cursor


        def dbcommit(self):
            self.trans.commit()

else:
    database = os.environ.get('OPENSHIFT_POSTGRESQL_DB_URL', 'postgresql://adminnjsu6cv:Idcyv4biae5j@127.8.72.130:5432/siteapi')


class DBconn:
    def __init__(self):

        engine = create_engine(database)
        self.conn = engine.connect()
        self.trans = self.conn.begin()

    def getcursor(self):
        cursor = self.conn.connection.cursor()
        return cursor

    def dbcommit(self):
        self.trans.commit()



def call_stored_procedure(qry, param, commit=False):
    try:
        dbo = DBconn()
        cursor = dbo.getcursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            dbo.dbcommit()
        return res

    except:
        res = [("Error: " + str(sys.exc_info()[0]) + " " + str(sys.exc_info()[1]),)]

    return res
