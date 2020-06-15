import random
import string
import psycopg2 
from flask import Flask
app = Flask(__name__)

letters = string.ascii_lowercase
api_id =  ''.join(random.choice(letters) for i in range(10))

@app.route('/')
def hello():
    ## in prod design, keep connection alive and restart when unhealthy 
    conn = psycopg2.connect(dbname="api", user="postgres", host="db", port="5432", password="use-a-key-vault-next-time")
    cur = conn.cursor() 
    ## get total visits 
    cur.execute("SELECT total FROM visits") 
    visits = cur.fetchone()[0]  
    ## update total visits 
    cur.execute("UPDATE visits SET total = total + 1") 
    conn.close() 
    return 'pod name: ' + str(api_id) + '\ntotal visits: ' + str(visits) + '\n'


@app.route('/healthy')
def health():
    return "200", 200

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
