#!/bin/zsh

omit_output=$(test -e ~/bin/screen.reboot && ~/bin/screen.reboot &)
test -e ~/.mutt/scripts/msmtpqueue && { print "Starting msmtp-daemon..."; ps -C msmtp-daemon.sh &>/dev/null || ~/.mutt/scripts/msmtpqueue/msmtp-daemon.sh; }
test -e ~/src/apps/phenny/ && { print "Starting phenny..."; pushd -q ~/src/apps/phenny/ && python phenny &>/dev/null &! popd -q}

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

