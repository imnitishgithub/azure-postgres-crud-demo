import os
import psycopg2
import json

def get_conn():
    host = os.environ.get('PG_HOST')
    db = os.environ.get('PG_DB', 'demo_db')
    user = os.environ.get('PG_USER')
    password = os.environ.get('PG_PASSWORD')
    conn = psycopg2.connect(
        host=host,
        database=db,
        user=user,
        password=password,
        sslmode='require'
    )
    return conn

def run_query(query, params=None, fetch=True):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(query, params or ())
    data = None
    if fetch:
        try:
            cols = [desc[0] for desc in cur.description] if cur.description else []
            rows = cur.fetchall() if cur.description else []
            data = [dict(zip(cols, r)) for r in rows] if rows else []
        except Exception:
            data = None
    conn.commit()
    cur.close()
    conn.close()
    return data
