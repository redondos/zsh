#!/bin/zsh

omit_output=$(~/bin/screen.reboot &)
ps -C msmtp-daemon.sh &>/dev/null || ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh
omit_output=$(cd ~/src/apps/phenny/ && python phenny &!)

if [[ -r ~/.xinitrc && -z $SSH_CLIENT ]]; then
	print '\n\nLogin shell: starting X11'
	startx &! logout
fi

# TODO: .zlogout
# kill:
# tin
# mutt
# irssi
# screen
# msmtp-daemon.sh
# zsh

