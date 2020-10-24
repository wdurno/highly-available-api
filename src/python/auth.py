from flask import session, redirect, url_for 

def verify_oauth_token():
    '''
    Verifies that a user is indeed logged-in. 
    Returns `True` if logged-in, `False` otherwise. 
    '''
    try:
        ## This is not a dictionary, flask sessions store data in signed cookies. 
        ## A key error is thrown if not logged in or a forgery is caught. 
        _ = session['token_cache'] 
        return True 
    except KeyError:
        ## User is not logged-in, time to redirect to login. 
        return False 

def redirect_to_login_and_return(endpoint_path: str): 
    '''
    Redirects a user to login. 
    After successful login, the user will be redirected back to `endpoint_path`. 
    Requires Flask's `app.config.HOST` to be configured (ie. 'www.example.com'). 
    inputs:
     - `endpoint_path`: (str) path to return to after login (ie. '/index'). Can be result of `url_for`. 
    '''
    ## get host 
    host = app.config.HOST 
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
    session['login_downstream'] = host + endpoint_path
    return redirect(host + '/oauth2/login') 

