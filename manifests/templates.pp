# All server templates for various flavors of templates defined here
class baseclass {
	include $operatingsystem,
		afs,
		cron,
		dns,
		puppetclient,
		ssh,
		unixadmin_users,
		user_root,
		virt_all_users
}

node default {
	include baseclass
}

class genericwebserver {
	include baseclass
	include apache, apachelocal
}

	