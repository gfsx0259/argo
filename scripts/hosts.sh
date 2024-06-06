#!/bin/bash

HOSTSFILE="/etc/hosts"
BAKFILE="$HOSTSFILE.bak"
DOMAINREGEX="^[a-zA-Z0-9]{1}[a-zA-Z0-9\.\-]+$"
IPREGEX="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
URLREGEX="^https?:\/\/[a-zA-Z0-9]{1}[a-zA-Z0-9\/\.\-]+$"

backup() {
	cat $HOSTSFILE > $BAKFILE
}

usage() {
	echo "Commands:"
	echo "- add      <host> <ip>"
	echo "- remove   <host>"
	echo "- update   <host> <ip>"
	echo "- check    <host>"
	echo "- rollback"
	echo "- import   <file or url> [--append]"
	echo "- export   <file>"
	echo ""
}

isroot() {
	if [ $(whoami) != "root" ]; then
		echo "You must run this script as root."
		exit 1
	fi
}

echo ""

case $1 in
	add )
		isroot

		if [ ! $# == 3 ]; then
			echo "Incorrect Usage: add <host> <ip>"
			exit 1
		fi

		if [[ ! $2 =~ $DOMAINREGEX ]]; then
			echo "Invalid host: \"$2\""
			exit 1
		fi

		if [[ ! $3 =~ $IPREGEX ]]; then
			echo "Invalid IP: \"$3\""
			exit 1
		fi

		REGEX="${2}$"

		if [ $(cat $HOSTSFILE | grep $REGEX | wc -l | sed 's/^ *//g') != 0 ]; then
			echo "Unable to add host \"$2\" because it already exists."
			exit 1
		fi

		echo -e "$3\t$2" >> $HOSTSFILE

		echo "Successfully added host \"$2\"."
		exit 0
		;;

	check )
		if [ ! $# == 2 ]; then
			echo "Incorrect usage: check <host>"
			exit 1
		fi

		REGEX="${2}$"

		if [ $(cat $HOSTSFILE | grep $REGEX | wc -l | sed 's/^ *//g') != 0 ]; then
			cat $HOSTSFILE | grep $2
			exit 0
		else
			echo "Unable to check host \"$2\" because it does not exist."
			exit 1
		fi
		;;

	remove )
		if [ ! $# == 2 ]; then
			echo "Incorrect usage: remove <host>"
			exit 1
		fi

		isroot

		REGEX="$2$"

		if [ $(cat $HOSTSFILE | grep $REGEX | wc -l | sed 's/^ *//g') = 0 ]; then
			echo "Unable to remove host \"$2\" because it does not exist."
			exit 1
		fi

		backup

		cat $HOSTSFILE | sed -e "/$2$/ d" > tmp && mv tmp $HOSTSFILE

		echo "Successfully removed host \"$2\"."
		exit 0
		;;

	update )
		if [ ! $# == 3 ]; then
			echo "Incorrect usage: update <host> <ip>"
			exit 1
		fi

		isroot

		if [[ ! $3 =~ $IPREGEX ]]; then
			echo "Invalid IP: \"$3\""
			exit 1
		fi

		if [[ ! $2 =~ $DOMAINREGEX ]]; then
			echo "Invalid host: \"$2\""
			exit 1
		fi

		backup

		$0 remove $2

		$0 add $2 $3

		echo "Successfully updated host \"$2\" to \"$3\"."
		exit 0
		;;

	import )
		TEMPFILE="./hosts-import-$(date +%s).tmp"
		APPEND=0

		if [ ! $# -gt 1 ]; then
			echo "Incorrect usage: import <file> [--append]"
			exit 1
		fi

		isroot

		if [ ! -z $3 ]; then
			if [ $3 == "--append" ]; then
				APPEND=1
			fi
		fi

		if [[ $2 =~ $URLREGEX ]]; then
			echo "curl -s -o $TEMPFILE $2"
		else
			TEMPFILE=$2
		fi

		if [ -f $TEMPFILE ]; then
			backup

			IMPORTPREFIX="\n# IMPORTED FROM: $2\n";

			if [ $APPEND == 0 ]; then
				echo -e "$(head -n 11 $HOSTSFILE)$(echo $IMPORTPREFIX)$(cat $TEMPFILE)" > $HOSTSFILE

				echo "Successfully imported \"$2\"."
				exit 0
			else
				echo -e $IMPORTPREFIX >> $HOSTSFILE

				cat $TEMPFILE >> $HOSTSFILE

				echo "Successfully appended \"$2\""
				exit 0
			fi
		else
			echo "Invalid file"
			exit 1
		fi
		;;

	export )
		if [ ! $# == 2 ]; then
			echo "Usage: export <file>"
			exit 1
		fi

		isroot

		cat $HOSTSFILE > $2

		echo "Successfully exported to \"$2\""
		exit 0
		;;

	rollback )
		isroot

		if [ -f $BAKFILE ]; then
			cat $BAKFILE > $HOSTSFILE

			rm $BAKFILE

			echo "Successfully rolled back."
			exit 0
		else
			echo "Unable to roll back because no backup file exists."
			exit 1;
		fi
		;;

	-h )
		usage
		exit 0
		;;

	* )
		echo "Incorrect usage: -h for help"
		exit 1;
		;;

esac