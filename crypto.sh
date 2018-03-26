# This script contains a subset of frequently used openssl commands

# To sign a file: (a) generate a 256 bit hash of the file using a function
# such as sha256 and (b) sign the hash using your private key
sign_file_sha256() {
    private_key=$1
    file_to_sign=$2
    openssl dgst -sha256 -sign $private_key -out "$file_to_sign.sha256" $file_to_sign
    echo "The signature has been saved to $file_to_sign.sha256"
}

sign_file() {
    echo -n "Enter filename of private key: "
    read private_key
    echo -n "Enter filename to be signed: "
    read file_to_sign
    sign_file_sha256 $private_key $file_to_sign
}

verify_signature() {
    echo -n "Enter filename of certificate: "
    read certificate
    echo -n "Enter filename of signature: "
    read signature
    echo -n "Enter filename that was signed: "
    read file_signed
    openssl dgst -sha256 -verify <(openssl x509 -in $certificate -pubkey -noout) -signature $signature $file_signed
}

# Use base 64 encoding if you need to post signature on public website
convert_signature_to_base64() {
    echo -n "Enter filename of signature: "
    read file_in
    echo -n "Enter output filename: "
    read file_out
    base64 $file_in > $file_out
}

convert_signature_from_base64() {
    echo -n "Enter filename of base64 signature: "
    read file_in
    echo -n "Enter output filename: "
    read file_out
    base64 -d $file_in > $file_out
}

generate_keypair() {
    openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout "key.pem" -out "cert.pem" -days 365
}

echo "[1] generate key pair"
echo "[2] sign file"
echo "[3] verify signature"
echo "[4] convert signature to base64"
echo "[5] convert signature from base64"
echo "[6] quit"
echo -n "make a selection: "
read choice

if [ $choice -eq 1 ]; then
    generate_keypair
elif [ $choice -eq 2 ]; then
    sign_file
elif [ $choice -eq 3 ]; then
    verify_signature
elif [ $choice -eq 4 ]; then
    convert_signature_to_base64
elif [ $choice -eq 5 ]; then
    convert_signature_from_base64
elif [ $choice -eq 6 ]; then
    exit 0
else
    echo "invalid selection"
    exit 1
fi
