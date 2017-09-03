# make stamp
DATE=$(date +%Y-%m-%d-%I-%M-%S-%p)
export DATE

echo "Date: $DATE"

echo "compressing folders"
tar -cvzpf $DATE.gz main_database/

echo "encrypting"
echo $CHARLIE | gpg --symmetric --cipher-algo aes256 --output "backup_$DATE.gpg" --passphrase-fd 0 --batch --yes  $DATE.gz

mv "backup_$DATE.gpg" stage/

rm $DATE.gz

echo "$DATE" >> log
