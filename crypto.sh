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

echo "[1] sign file"
echo "[2] generate public/private key pair"
echo "[3] quit"
echo -n "make a selection: "
read choice

if [ $choice -eq 1 ]; then
    sign_file
elif [ $choice -eq 2 ]; then
    echo "you entered 2"
elif [ $choice -eq 3 ]; then
    exit 0
else
    echo "invalid selection"
    exit 1
fi
