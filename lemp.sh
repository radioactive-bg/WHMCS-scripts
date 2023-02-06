#!/bin/bash
set -x
IFS=

NGINX_CONF="dXNlciB3d3ctZGF0YTsgCndvcmtlcl9wcm9jZXNzZXMgIDE7CgplcnJvcl9sb2cgIC92YXIvbG9nL25naW54L2Vycm9yLmxvZyB3YXJuOwpwaWQgICAgICAgIC92YXIvcnVuL25naW54LnBpZDsKCgpldmVudHMgewogICAgd29ya2VyX2Nvbm5lY3Rpb25zICAxMDI0Owp9CgoKaHR0cCB7CiAgICBzZXJ2ZXJfbmFtZXNfaGFzaF9idWNrZXRfc2l6ZSAxMjg7CgogICAgaW5jbHVkZSAgICAgICAvZXRjL25naW54L21pbWUudHlwZXM7CiAgICBkZWZhdWx0X3R5cGUgIGFwcGxpY2F0aW9uL29jdGV0LXN0cmVhbTsKCiAgICBsb2dfZm9ybWF0ICBtYWluICAnJHJlbW90ZV9hZGRyIC0gJHJlbW90ZV91c2VyIFskdGltZV9sb2NhbF0gIiRyZXF1ZXN0IiAnCiAgICAgICAgICAgICAgICAgICAgICAnJHN0YXR1cyAkYm9keV9ieXRlc19zZW50ICIkaHR0cF9yZWZlcmVyIiAnCiAgICAgICAgICAgICAgICAgICAgICAnIiRodHRwX3VzZXJfYWdlbnQiICIkaHR0cF94X2ZvcndhcmRlZF9mb3IiJzsKCiAgICBhY2Nlc3NfbG9nICAvdmFyL2xvZy9uZ2lueC9hY2Nlc3MubG9nICBtYWluOwoKCiAgICBmYXN0Y2dpX2J1ZmZlcnMgMTYgMTZrOwogICAgZmFzdGNnaV9idWZmZXJfc2l6ZSAzMms7CgogICAgc2VuZGZpbGUgICAgICAgIG9mZjsKICAgICN0Y3Bfbm9wdXNoICAgICBvbjsKCiAgICBrZWVwYWxpdmVfdGltZW91dCAgNjU7CgogICAgI2d6aXAgIG9uOwogICAgc2VydmVyX3Rva2VucyBvZmY7CgogICAgc2VydmVyIHsKICAgICAgICBsaXN0ZW4gICAgICAgODA7CiAgICAgICAgc2VydmVyX25hbWUgIF87CiAgICAgICAgcm9vdCAvcHJvamVjdC93ZWI7CiAgICAgICAgY2xpZW50X21heF9ib2R5X3NpemUgMTI3TTsKICAgICAgICBpbmRleCBpbmRleC5waHA7CgogICAgICAgIGFkZF9oZWFkZXIgWC1YU1MtUHJvdGVjdGlvbiAiMTsgbW9kZT1ibG9jayI7CiAgICAgICAgYWRkX2hlYWRlciBYLUZyYW1lLU9wdGlvbnMgREVOWTsKICAgICAgICBhZGRfaGVhZGVyIFgtQ29udGVudC1UeXBlLU9wdGlvbnMgbm9zbmlmZjsKCWxvY2F0aW9uIC8gewogICAgICAgIHRyeV9maWxlcyAkdXJpICR1cmkvIC9pbmRleC5waHA/JHF1ZXJ5X3N0cmluZzsKICAgICAgICB9CiAgICAgICAgbG9jYXRpb24gfiBcLnBocCQgewogICAgICAgIGZhc3RjZ2lfcGFzcyB1bml4Oi92YXIvcnVuL3BocC9waHA3LjQtZnBtLnNvY2s7CiAgICAgICAgZmFzdGNnaV9wYXJhbSBTQ1JJUFRfRklMRU5BTUUgJHJlYWxwYXRoX3Jvb3QkZmFzdGNnaV9zY3JpcHRfbmFtZTsKICAgICAgICBpbmNsdWRlIGZhc3RjZ2lfcGFyYW1zOwogICAgICAgIH0KICAgIH0KfQo="

NGINX_CONF_DECODED=$( echo "${NGINX_CONF}"| base64 -d )
echo -n ${NGINX_CONF_DECODED} 
if [ -f "/etc/nginx/conf.d/default.conf" ]; then
        rm -f /etc/nginx/conf.d/default
fi
apt install -y nginx && \
echo -n "${NGINX_CONF_DECODED}" &> /etc/nginx/nginx.conf && \
service nginx restart #updating your server’s package
sudo apt update
sudo add-apt-repository -yu ppa:ondrej/php
sudo useradd -m -d /project/ www-data
sudo mkdir /var/log/php
chown www-data:www-data /var/log/php
sudo mkdir /project/
chown www-data:www-data /project/

# Install cloud-init and nginx and ntp
sudo apt -y install cloud-init nginx ntp

# Stop and disable UFW service
sudo service ufw stop && service ufw disable

# Install MySQL
sudo apt install mysql-server mysql-client -y

# Start and enable mysql
systemctl start mysql
systemctl enable mysql

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections

# Install PHP
sudo apt install php7.4-fpm php7.4-mysql -y

# Start and enable PHP7.4-fpm
sudo systemctl start php7.4-fpm
sudo systemctl enable php7.4-fpm


# Install some design software 
sudo apt install -y curl \
    apt-utils\
    unzip \
    git \
    wget \
    libfreetype6-dev \
    libbz2-dev libicu-dev \
    libzip-dev libcurl4-openssl-dev libonig-dev libxslt1-dev  zlib1g-dev libxml2-dev libpq-dev libjpeg-turbo8-dev

# Install PHP7.4 extensions
sudo apt install -y php7.4-common php7.4-mysql php7.4-gd php7.4-zip php7.4-curl php7.4-bz2 php7.4-intl php7.4-soap php7.4-bcmath php7.4-opcache php7.4-mbstring \
php7.4-json php7.4-xmlrpc php7.4-xsl


echo "date.timezone=UTC" > /etc/php/7.4/fpm/timezone.ini && \
	echo "display_errors=Off" > /etc/php/7.4/fpm/conf.d/display_errors.ini && \
	echo "log_errors=On" > /etc/php/7.4/fpm/conf.d/log_errors.ini && \
       	echo "error_log=php://stderr" > /etc/php/7.4/fpm/conf.d/error_log.ini && \
       	echo "error_reporting=E_ALL" > /etc/php/7.4/fpm/conf.d/error_reporting.ini && \
	echo "memory_limit=1024M" > /etc/php/7.4/fpm/conf.d/memory_limit.ini && \
	echo "expose_php=Off" > /etc/php/7.4/fpm/conf.d/expose_php.ini && \
	echo "post_max_size=126M" > /etc/php/7.4/fpm/conf.d/file_max_size.ini && \
	echo "upload_max_filesize=126M" >> /etc/php/7.4/fpm/conf.d/file_max_size.ini
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer 
cat << EOF > /etc/ssl/openssl.cnf
#
# OpenSSL example configuration file.
# This is mostly being used for generation of certificate requests.
#

# Note that you can include other files from the main configuration
# file using the .include directive.
#.include filename

# This definition stops the following lines choking if HOME isn't
# defined.
HOME                    = .

# Extra OBJECT IDENTIFIER info:
#oid_file               = $ENV::HOME/.oid
oid_section             = new_oids

# System default
openssl_conf = default_conf

# To use this configuration file with the "-extfile" option of the
# "openssl x509" utility, name here the section containing the
# X.509v3 extensions to use:
# extensions            =
# (Alternatively, use a configuration file that has only
# X.509v3 extensions in its main [= default] section.)

[ new_oids ]

# We can add new OIDs in here for use by 'ca', 'req' and 'ts'.
# Add a simple OID like this:
# testoid1=1.2.3.4
# Or use config file substitution like this:
# testoid2=${testoid1}.5.6

# Policies used by the TSA examples.
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7

####################################################################
[ ca ]
default_ca      = CA_default            # The default ca section

####################################################################
[ CA_default ]

dir             = ./demoCA              # Where everything is kept
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
#unique_subject = no                    # Set to 'no' to allow creation of
                                        # several certs with same subject.
new_certs_dir   = $dir/newcerts         # default place for new certs.

certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crlnumber       = $dir/crlnumber        # the current crl number
                                        # must be commented out to leave a V1 CRL
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem# The private key

x509_extensions = usr_cert              # The extensions to add to the cert

# Comment out the following two lines for the "traditional"
# (and highly broken) format.
name_opt        = ca_default            # Subject Name options
cert_opt        = ca_default            # Certificate field options

# Extension copying option: use with caution.
# copy_extensions = copy

# Extensions to add to a CRL. Note: Netscape communicator chokes on V2 CRLs
# so this is commented out by default to leave a V1 CRL.
# crlnumber must also be commented out to leave a V1 CRL.
# crl_extensions        = crl_ext

default_days    = 365                   # how long to certify for
default_crl_days= 30                    # how long before next CRL
default_md      = default               # use public key default MD
preserve        = no                    # keep passed DN ordering

# A few difference way of specifying how similar the request should look
# For type CA, the listed attributes must be the same, and the optional
# and supplied fields are just that :-)
policy          = policy_match

# For the CA policy
[ policy_match ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

# For the 'anything' policy
# At this point in time, you must list all acceptable 'object'
# types.
[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

####################################################################
[ req ]
default_bits            = 2048
default_keyfile         = privkey.pem
distinguished_name      = req_distinguished_name
attributes              = req_attributes
x509_extensions = v3_ca # The extensions to add to the self signed cert

# Passwords for private keys if not present they will be prompted for
# input_password = secret
# output_password = secret

# This sets a mask for permitted string types. There are several options.
# default: PrintableString, T61String, BMPString.
# pkix   : PrintableString, BMPString (PKIX recommendation before 2004)
# utf8only: only UTF8Strings (PKIX recommendation after 2004).
# nombstr : PrintableString, T61String (no BMPStrings or UTF8Strings).
# MASK:XXXX a literal mask value.
# WARNING: ancient versions of Netscape crash on BMPStrings or UTF8Strings.
string_mask = utf8only

# req_extensions = v3_req # The extensions to add to a certificate request

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
countryName_default             = AU
countryName_min                 = 2
countryName_max                 = 2

stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Some-State

localityName                    = Locality Name (eg, city)

0.organizationName              = Organization Name (eg, company)
0.organizationName_default      = Internet Widgits Pty Ltd

# we can do this but it is not needed normally :-)
#1.organizationName             = Second Organization Name (eg, company)
#1.organizationName_default     = World Wide Web Pty Ltd

organizationalUnitName          = Organizational Unit Name (eg, section)
#organizationalUnitName_default =

commonName                      = Common Name (e.g. server FQDN or YOUR name)
commonName_max                  = 64

emailAddress                    = Email Address
emailAddress_max                = 64

# SET-ex3                       = SET extension number 3

[ req_attributes ]
challengePassword               = A challenge password
challengePassword_min           = 4
challengePassword_max           = 20

unstructuredName                = An optional company name

[ usr_cert ]

# These extensions are added when 'ca' signs a request.

# This goes against PKIX guidelines but some CAs do it and some software
# requires this to avoid interpreting an end user certificate as a CA.

basicConstraints=CA:FALSE

# Here are some examples of the usage of nsCertType. If it is omitted
# the certificate can be used for anything *except* object signing.

# This is OK for an SSL server.
# nsCertType                    = server

# For an object signing certificate this would be used.
# nsCertType = objsign

# For normal client use this is typical
# nsCertType = client, email

# and for everything including object signing:
# nsCertType = client, email, objsign

# This is typical in keyUsage for a client certificate.
# keyUsage = nonRepudiation, digitalSignature, keyEncipherment

# This will be displayed in Netscape's comment listbox.
nsComment                       = "OpenSSL Generated Certificate"

# PKIX recommendations harmless if included in all certificates.
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

# This stuff is for subjectAltName and issuerAltname.
# Import the email address.
# subjectAltName=email:copy
# An alternative to produce certificates that aren't
# deprecated according to PKIX.
# subjectAltName=email:move

# Copy subject details
# issuerAltName=issuer:copy

#nsCaRevocationUrl              = http://www.domain.dom/ca-crl.pem
#nsBaseUrl
#nsRevocationUrl
#nsRenewalUrl
#nsCaPolicyUrl
#nsSslServerName

# This is required for TSA certificates.
# extendedKeyUsage = critical,timeStamping

[ v3_req ]

# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v3_ca ]


# Extensions for a typical CA


# PKIX recommendation.

subjectKeyIdentifier=hash

authorityKeyIdentifier=keyid:always,issuer

basicConstraints = critical,CA:true

# Key usage: this is typical for a CA certificate. However since it will
# prevent it being used as an test self-signed certificate it is best
# left out by default.
# keyUsage = cRLSign, keyCertSign

# Some might want this also
# nsCertType = sslCA, emailCA

# Include email address in subject alt name: another PKIX recommendation
# subjectAltName=email:copy
# Copy issuer details
# issuerAltName=issuer:copy

# DER hex encoding of an extension: beware experts only!
# obj=DER:02:03
# Where 'obj' is a standard or added object
# You can even override a supported extension:
# basicConstraints= critical, DER:30:03:01:01:FF

[ crl_ext ]

# CRL extensions.
# Only issuerAltName and authorityKeyIdentifier make any sense in a CRL.

# issuerAltName=issuer:copy
authorityKeyIdentifier=keyid:always

[ proxy_cert_ext ]
# These extensions should be added when creating a proxy certificate

# This goes against PKIX guidelines but some CAs do it and some software
# requires this to avoid interpreting an end user certificate as a CA.

basicConstraints=CA:FALSE

# Here are some examples of the usage of nsCertType. If it is omitted
# the certificate can be used for anything *except* object signing.

# This is OK for an SSL server.
# nsCertType                    = server

# For an object signing certificate this would be used.
# nsCertType = objsign

# For normal client use this is typical
# nsCertType = client, email

# and for everything including object signing:
# nsCertType = client, email, objsign

# This is typical in keyUsage for a client certificate.
# keyUsage = nonRepudiation, digitalSignature, keyEncipherment

# This will be displayed in Netscape's comment listbox.
nsComment                       = "OpenSSL Generated Certificate"

# PKIX recommendations harmless if included in all certificates.
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

# This stuff is for subjectAltName and issuerAltname.
# Import the email address.
# subjectAltName=email:copy
# An alternative to produce certificates that aren't
# deprecated according to PKIX.
# subjectAltName=email:move

# Copy subject details
# issuerAltName=issuer:copy

#nsCaRevocationUrl              = http://www.domain.dom/ca-crl.pem
#nsBaseUrl
#nsRevocationUrl
#nsRenewalUrl
#nsCaPolicyUrl
#nsSslServerName

# This really needs to be in place for it to be a proxy certificate.
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo

####################################################################
[ tsa ]

default_tsa = tsa_config1       # the default TSA section

[ tsa_config1 ]

# These are used by the TSA reply generation only.
dir             = ./demoCA              # TSA root directory
serial          = $dir/tsaserial        # The current serial number (mandatory)
crypto_device   = builtin               # OpenSSL engine to use for signing
signer_cert     = $dir/tsacert.pem      # The TSA signing certificate
                                        # (optional)
certs           = $dir/cacert.pem       # Certificate chain to include in reply
                                        # (optional)
signer_key      = $dir/private/tsakey.pem # The TSA private key (optional)
signer_digest  = sha256                 # Signing digest to use. (Optional)
default_policy  = tsa_policy1           # Policy if request did not specify it
                                        # (optional)
other_policies  = tsa_policy2, tsa_policy3      # acceptable policies (optional)
digests     = sha1, sha256, sha384, sha512  # Acceptable message digests (mandatory)
accuracy        = secs:1, millisecs:500, microsecs:100  # (optional)
clock_precision_digits  = 0     # number of digits after dot. (optional)
ordering                = yes   # Is ordering defined for timestamps?
                                # (optional, default: no)
tsa_name                = yes   # Must the TSA name be included in the reply?
                                # (optional, default: no)
ess_cert_id_chain       = no    # Must the ESS cert id chain be included?
                                # (optional, default: no)
ess_cert_id_alg         = sha1  # algorithm to compute certificate
                                # identifier (optional, default: sha1)
[default_conf]
ssl_conf = ssl_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
MinProtocol = TLSv1.2
#CipherString = DEFAULT@SECLEVEL=2
EOF

sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/UTC /etc/localtime
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/UTC /etc/localtime
sudo apt install php-pear
wget https://phar.phpunit.de/phpunit-6.5.phar
chmod +x phpunit-6.5.phar
sudo mv phpunit-6.5.phar /usr/local/bin/phpunit
dpkg-reconfigure openssh-server


