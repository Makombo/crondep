#!/bin/sh

#Configs
	the_key=$HOME/.ssh/id_rsa

	ssh-keygen -t rsa -N "" -f $the_key #needs more enter buttons
	
	ssh-add $the_key
	cat $the_key.pub
	#TODO: RESTfully add key to $my_origin.pub
	echo ""
	echo ".. Press Anykey when you have added this deoployment key to your remote repository" 
