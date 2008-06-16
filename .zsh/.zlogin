#!/bin/zsh

if [[ -n $SSH_CONNECTION ]]; then
	omit_output=$(test -e ~/bin/screen.reboot && ~/bin/screen.reboot &)
	test -e ~/.mutt/scripts/msmtpqueue && ps -C msmtp-daemon.sh &>/dev/null || { print "Starting msmtp-daemon..."; ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh; }

	if [[ -r ~/.xinitrc && -z $SSH_CLIENT ]]; then
		print '\n\nLogin shell: starting X11'
		startx &! logout
	fi
fi

# TODO: .zlogout
# kill:
# tin
# mutt
# irssi
# screen
# msmtp-daemon.sh
# zsh

