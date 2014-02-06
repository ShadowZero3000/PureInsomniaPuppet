node 'raven.pureinsomnia.com' inherits basenode {
	$web_fqdn = 'www.pureinsomnia.com'
	include genericwebserver
	include pureinsomnia_apache
}