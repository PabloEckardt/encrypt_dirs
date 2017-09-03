read -p "file: " FILE_NAME

read -s -p "password: " FILE_PASS

echo $FILE_PASS | gpg -o restored.gz --batch --passphrase-fd  0 --decrypt $FILE_NAME
