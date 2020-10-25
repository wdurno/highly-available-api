from flask import session, request, redirect, url_for 
import urllib.parse 
import requests

def verify_oauth_token():
    '''
    Verifies that a user is indeed logged-in. 
    Returns `True` if logged-in, `False` otherwise. 
    '''
    ## get cookies 
    cookies = dict(request.cookies) 
    ## request local service 
    r = requests.get('http://oauth2-service:8080/oauth2', cookies=cookies)
    return r.json()['logged_in'] 

def redirect_to_login_and_return(app, endpoint_path: str): 
    '''
    Redirects a user to login. 
    After successful login, the user will be redirected back to `endpoint_path`. 
    Requires Flask's `app.config['HOST']` to be configured (ie. 'www.example.com'). 
    inputs:
     - `app`: (Flask instance) 
     - `endpoint_path`: (str) path to return to after login (ie. '/index'). Can be result of `url_for`. 
    '''
    ## get host 
    host = app.config['HOST']  
    ## enforce formatting
    if not endpoint_path.startswith('/'): 
        endpoint_path = '/' + endpoint_path 
    if type(host) != str:
        raise ValueError('Host must be a string starting with https://, example: https://www.example.com') 
    if host.startswith('http://'): 
        host = host.replace('http://', 'https://') 
    if not host.startswith('https://'): 
        host = 'https://' + host 
    ## construct redirects 
    login_downstream = host + endpoint_path
    login_downstream = urllib.parse.urlencode({'login-downstream': login_downstream}) 
    return redirect(host + '/oauth2/login?' + login_downstream) 

