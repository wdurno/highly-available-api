
# certs 

Certificates enable secure communication via HTTPS.

## Best option

Register your organization with a certificate authority and get a cert which will be trusted by browsers, then use the cert here. This takes time and money. Please copy certs into this directory with the names `cacert.crt` and `cacert.key`.

## Default option: Self-signed cert

Using the `make-cert.sh` script will provide you with a self-signed cert, which is fine for communication between trusting parties. However, it does not use a third-party certifacate authority, so browsers will likely throw "untrusted host" warnings.

The script will ask you a few questions. Only one matters, "Common Name" needs your domain. All other fields can be blank. 

Here's an example execution. 
```
. make-cert.sh
Generating a 4096 bit RSA private key
....................................................................................................................................................................................................................................++
................................................................................................................................................................................................................................++
writing new private key to 'cacert.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:doman.com
Email Address []:
```

