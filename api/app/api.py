import random
import string
import psycopg2 
import argparse 
from flask import Flask, url_for, jsonify 
from waitress import serve
from auth import verify_oauth_token, redirect_to_login_and_return 
app = Flask(__name__)

letters = string.ascii_lowercase
api_id =  ''.join(random.choice(letters) for i in range(10))

parser = argparse.ArgumentParser(description='Increments and reports visits statelessly. Requires AAD authentication.') 
parser.add_argument('--host', required=True, type=str, help='host name, ie. https://www.example.com, https:// required.') 
parser.add_argument('--cookie-token', required=True, type=str, help='enables sessions by signing cookies') 
parser.add_argument('--db-password', required=False, default='use-a-key-vault-next-time', help='the database password')

@app.route('/')
def index():
    ## auth before proceeding 
    if not verify_oauth_token():
        return redirect_to_login_and_return(app, url_for('index')) 
    ## in prod design, keep connection alive and restart when unhealthy 
    conn = psycopg2.connect(dbname="api", user="postgres", host="db", port="5432", password=app.config['DB_PASSWORD'])
    cur = conn.cursor() 
    ## get total visits 
    cur.execute("SELECT total FROM visits") 
    visits = cur.fetchone()[0]  
    ## update total visits 
    cur.execute("UPDATE visits SET total = total + 1") 
    conn.commit() 
    conn.close() 
    return jsonify({'pod-name': str(api_id), 'total-visits': str(visits)})

@app.route('/healthy')
def health():
    return "200", 200

if __name__ == '__main__':
    args = parser.parse_args() 
    app.config.update(
            HOST=args.host,
            DB_PASSWORD=args.db_password
            )
    app.secret_key=args.cookie_token
    serve(app, host='0.0.0.0', port=5000) # production-grade serving  
