echo "creating a private key"
openssl genrsa -des3 -out devpi.key 2048

echo "creating a certificate signing request"
openssl req -new -key devpi.key -out devpi.csr

echo "removing the passphrase from the key"
mv devpi.key devpi.key.org
openssl rsa -in devpi.key.org -out devpi.key

echo "self-signing the certificate the private key"
openssl x509 -req -days 365 -in devpi.csr -signkey devpi.key -out devpi.crt

echo "cleaning up"
rm -f devpi.key.org devpi.csr
