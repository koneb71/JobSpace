from sqlalchemy import create_engine
import os
import sys

class DBconn:
    def __init__(self):
        engine = create_engine("postgresql://postgres:I hope life isnt a joke, because I dont get it@localhost:5432/jobspace")
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
