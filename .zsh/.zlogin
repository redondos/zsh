#!/bin/zsh

omit_output=$(test -e ~/bin/screen.reboot && ~/bin/screen.reboot &)
test -e ~/.mutt/scripts/msmtpqueue && ps -C msmtp-daemon.sh &>/dev/null || ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh
omit_output=$(test -e ~/src/apps/phenny/ && cd ~/src/apps/phenny/ && python phenny &!)

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

