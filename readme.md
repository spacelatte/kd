# keydistribute, ssh key-deployment made easy

lets say you are managing multiple servers at once and you have multiple user accounts with multiple keys from different persons

thats the tool pushing their public keys to servers, adding/removing them automatically from them

### let me explain

first there is users directory where public keys stored even the ones not being used for now

second there is folder machines, it has configs named host.user.conf.
where host may be an ip or casual hostname (anyways im passing it to ssh)

some important note about user, username cannot contain dot (for now)

adding or removing users from hosts easy as adding their name or removing them from config file.

users: keys of users (.pub files)
machines: username/host pairs and configs for them (including allowed user lists)

### installing

	git clone http://github.com/pvtmert/kd.git
	cd kd
	cp ~/.ssh/id_rsa.pub users/myself.pub # add myself to allow all

of course add your own configs, and remove default ones.

### running

just run make as usually you do in source codes...

	kd$ make
	compiling guest@example.org
	adding: mert
	Enter password for "example machine" if prompted...
	guest@example.org aka "example machine" is completed

or just one host

	kd$ make machines/example.com.admin.conf
	compiling admin@example.com
	adding: john
	Enter password for "example.com admin" if prompted...
	admin@example.com aka "example.com admin" is completed

### host file contents:

first line of host file is its common name, like "my web server" or "johns wordpress site"

other lines are the names of users (each on one line) which are public keys allowed (pushed to server)

lines starting with '#' being ignored (comments), also empty lines being ignored too

### examples

lets say we have dir structure like this

	users:
		id_rsa.pub
		john.pub
		alice.pub
		bob.pub
		guest.pub
		bot.pub
	machines:
		example.com.root.conf
		example.com.mod.conf
		example.org.web.conf

okay, so contents of files like that

##### example.com.root.conf:

	# example.com
	# root's allowed list
	# common name:
	example.com ROOT account
	
	# myself
	id_rsa
	
	# let johnny manage
	john

##### example.com.mod.conf:

	# example.com
	# moderator account (mod)
	# c-name
	example.com moderation
	
	# myself
	id_rsa
	
	# mods
	alice
	bob
	bot

##### example.org.web.conf:

	# example.org
	# web cleanup list
	# cname
	
	# myself
	id_rsa

	# assigned people:
	bot
	john


note: i'm always adding myself so i dont have to enter password when updating...
