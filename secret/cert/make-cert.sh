if [ -z ${repo_dir} ]
then
	  echo ERROR! repo_dir not set! Run from build.sh
	    exit 1
fi

CERT_PATH=${repo_dir}/secret/cert/cacert.crt
KEY_PATH=${repo_dir}/secret/cert/cacert.key

if [ ! -f "${CERT_PATH}" ] || [ ! -f "${KEY_PATH}" ]
then
	openssl req -newkey rsa:4096 -nodes -sha512 -x509 -days 3650 -nodes \
		-out ${CERT_PATH} -keyout ${KEY_PATH}
fi 
