# encrypt_dirs
Weekend project #4 basic scripts to script encrypting of general folders and files.


Amounting to just another tiny weekend project this is how I like to recursive store files in encrypted files
using AES-256. 

### Requirements 

1. Linux Distro
2. tar and gpg

### Guide

There are multiple ways to do this, I'll try to explain my thoughts for doing it this way.

1. 7z won't support compressing files in such a way that your file permissions will be conserved. This can, and will
be an issue if you intend to store away a more complicated type of folder such as an application or any file that interfaces with other
parts of the system. 
 
The man pages for 7z clearly state to not 7z as a backup tool. 

2. tar can use high levels of compression by using the -J parameter for xz compression. There are several different options Gz being another useful one. 

3. This wouldn't be fun if we can't script all of our actions. 


We will be doing the following set of actions which are all in series in encrypt.sh 

take folder a and turn it into a tar ball, encrypt it, decrypt it, and untar it


try it:

	chmod +x encrypt.sh; ./encrypt.sh

## Making a tar file out of a directory

We do this because gpg won't encrypt a folder, it needs to be a single file. A disadvantage of this method as opposed of using
7zip is hardwear wear. we will be doing a lot of work twice. As the same data will exist duplicated in the tar binary and the encrypted file. (A lot more disk writes). I hope you aren't reading this on an post-apocalyptic dystopia where hard drives are hard to get. Because right now they are dirt cheap.

#### format tar [options] [name] [target]

tar -cvJpf backup.tar.xz a/

c = create
J = xz compression
v = verbose
p = preserve permissions
f = indicate file

## Encrypting a folder

We will be using a file to get our password. I shouldn't have to remind you to not do something like this outside of an example. 
I prefer using directories with special permissions to store passwords and then using environment variables.


	echo "password" > passphrase
	gpg --cipher-algo aes256 --output curr.gpg --passphrase-file ./passphrase --batch --yes --symmetric backup.tar.xz


curr.gpg is the output file


	--batch --yes allows us to pass in data in this shell environment rather than have it prompt the user. 


--symmetric as it implies it means encrypying with a symmetric cipher. 


	https://en.wikipedia.org/wiki/Symmetric-key_algorithm

## Decrypting folder


	echo "password" | gpg -o backup.tar.gz --batch --passphrase-fd  0 --armor --decrypt  curr.gpg


Notice we are using "echo" to pass the password, also notice that 
here we use --passphrase-fd 0. This is for the same reason we used --batch, to pass information to gpg via the shell and not the prompt.
This is just a slightly hackier way to do it as of right now --batch on --decrypt is wonky.  

--armor Create ASCII armored output. The default is to create the binary OpenPGP format.

## Retrieving your file from the tarball

you can just double click on it, but if you want to script it and do it remotely:


	tar -xvJf backup.tar.xz path/to/dir

--x indicates to untar
--J to indicate we are using xz compression

Keep your data safe!
