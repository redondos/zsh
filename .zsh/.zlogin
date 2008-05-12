#!/bin/zsh

omit_output=$(~/bin/screen.reboot &)
ps -C msmtp-daemon.sh &>/dev/null || ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh

if [[ -r ~/.xinitrc && -z $SSH_CLIENT ]]; then
	print '\n\nLogin shell: starting X11'
	startx
fi

# TODO: .zlogout
# kill:
# tin
# mutt
# irssi
# screen
# msmtp-daemon.sh
# zsh

