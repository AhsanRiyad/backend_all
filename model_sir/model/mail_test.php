<?php 


# Include the Autoloader (see "Libraries" for install instructions)
require 'vendor/autoload.php';
use Mailgun\Mailgun;
# Instantiate the client.
$mgClient = new Mailgun('db10340a0ca7674835fbc18a7098dfc6-f696beb4-0e458895');
$domain = "friedsbd";
# Make the call to the client.
$result = $mgClient->sendMessage($domain, array(
	'from'	=> 'Excited User <mailgun@friendsbd.com>',
	'to'	=> 'Baz <riyad298@gmail.com>',
	'subject' => 'Hello',
	'text'	=> 'Testing some Mailgun awesomness!'
));





