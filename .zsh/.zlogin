#!/bin/zsh

# Start on login
thruster=(msmtpqueue)

if [[ -z $SSH_CONNECTION ]]; then
	omit_output=$(test -e ~/bin/screen.reboot && ~/bin/screen.reboot &)

	# msmtpqueue
	if (( ${${(P)HOSTNAME}[(r)msmtpqueue]} )); then
		if test -e ~/.mutt/scripts/msmtpqueue; then
			ps -C msmtp-daemon.sh &>/dev/null || 
				{ print "Starting msmtp-daemon..."; ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh; }
		fi
	fi

	# x11
	if (( ${${(P)HOSTNAME}[(r)x11]} )); then
		if [[ -r ~/.xinitrc && -z $SSH_CLIENT ]]; then
			print '\n\nLogin shell: starting X11'
			startx &! logout
		fi
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

