
# setp 1. Self-Signed Certificate
openssl genrsa -des3 -out server.key 2048
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# setp 2. PKCS12 keystore 
cat server.key > server.pem 
cat server.crt >> server.pem
openssl pkcs12 -export -in server.pem -out keystore.pkcs12

# .key - private key
# .csr - certificate signing request
# .crt - certificate
# .pem - privacy enhanced mail
