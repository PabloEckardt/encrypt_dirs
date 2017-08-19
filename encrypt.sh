# tarball
tar -cvJpf backup.tar.xz a/
# encrypt
gpg --cipher-algo aes256 --output curr.gpg --passphrase-file ./passphrase --batch --yes --symmetric backup.tar.xz

# clean
rm backup.tar.xz

# decrypt
echo "password" | gpg -o backup.tar.xz --batch --passphrase-fd  0 --armor --decrypt  curr.gpg
# untar
tar -xvJf backup.tar.xz -C b/
