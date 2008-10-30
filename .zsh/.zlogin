#!/bin/zsh

# Start on login
thruster=(msmtpqueue anyremote)

if [[ -z $SSH_CONNECTION ]]; then
	omit_output=$(test -e ~/bin/screen.reboot && ~/bin/screen.reboot &)

	# msmtpqueue
	if [[ -n ${${(P)HOSTNAME}[(r)msmtpqueue]} ]]; then
		if test -e ~/.mutt/scripts/msmtpqueue; then
			ps -C msmtp-daemon.sh &>/dev/null ||
				{ print "Starting msmtp-daemon..."; ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh; }
		fi
	fi

	# x11
	if [[ -n ${${(P)HOSTNAME}[(r)x11]} ]]; then
		if [[ -r ~/.xinitrc && -z $SSH_CLIENT ]]; then
			print '\n\nLogin shell: starting X11'
			startx &! logout
		fi
	fi

	# anyremote
	if [[ -n ${${(P)HOSTNAME}[(r)anyremote]} ]]; then
		if which anyremote &>/dev/null; then
			ps -C anyremote &>/dev/null ||
				{ print "Starting anyremote..."; anyremote -f ~/.anyRemote/mplayer.cfg -s socket:5000 &>/dev/null &! }
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

