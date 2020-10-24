import uuid
import requests
from flask import Flask, render_template, session, request, redirect, url_for, jsonify
import msal
import argparse 
from waitress import serve
from auth import verify_oauth_token 

app = Flask(__name__)

parser = argparse.ArgumentParser(description='Azure Active Directory authentication sidecar app') 
parser.add_argument('--client-id', required=True, type=str, help='AAD client ID')
parser.add_argument('--client-secret', required=True, type=str, help='AAD client secret') 
parser.add_argument('--authority', required=True, type=str, help='AAD Oauth2 authority, example: https://login.microsoftonline.com/Enter_the_Tenant_Name_Here') 
parser.add_argument('--host', required=True, type=str, help='host name, ie. https://www.host.com. Must start with https://') 
parser.add_argument('--cookie-token', required=True, type=str, help='enables sessions thorugh signed cookies') 

@app.route("/oauth2")
def oauth2_index():
    logged_in = verify_oauth_token() 
    return jsonify({'logged_in': logged_in}) 

@app.route("/oauth2/login")
def login():
    session["state"] = str(uuid.uuid4())
    ## Construct AAD login request and redirect 
    auth_url = _build_auth_url(scopes=[], state=session["state"])
    return redirect(auth_url) 

@app.route('/oauth2/callback') 
def authorized():
    if request.args.get('state') != session.get("state"):
        return redirect(url_for("oauth2_index"))  # No-OP. Goes back to Index page
    ## We provided `state`. If AAD confirms, then token is secure. 
    if "error" in request.args:  # Authentication/Authorization failure
        return jsonify(_format_error(request.args)) 
    if request.args.get('code'):
        cache = _load_cache()
        ## requests token from AAD with auth code 
        result = _build_msal_app(cache=cache).acquire_token_by_authorization_code(
            request.args['code'],
            scopes=app.config.SCOPE,  # Misspelled scope would cause an HTTP 400 error here
            redirect_uri=url_for("authorized", _external=True))
        if "error" in result:
            return jsonify(_format_error(result)) 
        session["user"] = result.get("id_token_claims")
        ## login successful
        ## token provided by AAD
        ## saving token as a session cookie, meaning it is signed and stored client-side 
        _save_cache(cache)
    login_downstream = session.get('login_downstream') 
    if login_downstream is not None: 
        ## clear downstream 
        session['login_downstream'] = None 
        ## redirect to login_downstream 
        return redirect(login_downstream) 
    return redirect(url_for("oauth2_index"))

@app.route("/oauth2/logout")
def logout():
    session.clear()  # Wipe out user and its token cache from session
    return redirect(  # Also logout from your tenant's web session
        app.config.AUTHORITY + "/oauth2/v2.0/logout" +
        "?post_logout_redirect_uri=" + url_for("oauth2_index", _external=True))

## health endpoint isn't accessed from outside
## it's just for kubernetes 
@app.route('/healthy') 
def healthy():
    return '200', 200

def _format_error(result): 
    return {'error': result.get('error'), 'error_description': result.get('error_description')} 

def _load_cache():
    cache = msal.SerializableTokenCache()
    if session.get("token_cache"):
        cache.deserialize(session["token_cache"])
    return cache

def _save_cache(cache):
    if cache.has_state_changed:
        session["token_cache"] = cache.serialize()

def _build_msal_app(cache=None, authority=None):
    return msal.ConfidentialClientApplication(
        app.config.CLIENT_ID, authority=authority or app.config.AUTHORITY,
        client_credential=app.config.CLIENT_SECRET, token_cache=cache)

def _build_auth_url(authority=None, scopes=None, state=None):
    return _build_msal_app(authority=authority).get_authorization_request_url(
        scopes or [],
        state=state or str(uuid.uuid4()),
        redirect_uri=url_for("authorized", _external=True))

def _get_token_from_cache(scope=None):
    cache = _load_cache()  # This web app maintains one cache per session
    cca = _build_msal_app(cache=cache)
    accounts = cca.get_accounts()
    if accounts:  # So all account(s) belong to the current signed-in user
        result = cca.acquire_token_silent(scope, account=accounts[0])
        _save_cache(cache)
        return result

if __name__ == "__main__":
    args = parser.parse_args() 
    app.config.update(
            CLIENT_ID=args.client_id,
            CLIENT_SECRET=args.client_secret,
            AUTHORITY=args.authority,
            HOST=args.host, 
            REDIRECT_PATH='/oauth2/callback',
            SCOPE=[]  
            )
    app.secret_key=args.cookie_token
    serve(app, host='0.0.0.0', port=5000)
