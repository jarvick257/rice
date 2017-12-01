.PHONY: all templates thunderbird

GIT := $(HOME)/git/arch
CONF := $(HOME)/.config
OHMYZSH := $(HOME)/.oh-my-zsh
THUNDER := $(HOME)/.thunderbird
LIGHTDM := /etc/lightdm


SOURCES_I3 := $(shell find i3 -type f -name "*.conf")
SOURCES_SCRIPTS := $(shell find scripts -type f -name "*.sh" -or -name "*.py")

DEPS_I3 := $(SOURCES_I3:%=%.mconf)
DEPS_SCRIPTS := $(SOURCES_SCRIPTS:%=%.mconf)

.PHONY: all templates thunderbird
all: alias i3 scripts templates polybar termite zsh vim thunderbird xbindkeys ranger ncmpcpp mpd lightdm

%.mconf:
	./configParser.sh $(@:%.mconf=%) $@


alias: alias/alias.mconf
	mv $< $(HOME)/.alias

i3: $(DEPS_I3)
	[[ -f $(CONF)/i3/config ]] && rm $(CONF)/i3/config
	cat i3/*.mconf >> $(CONF)/i3/config
	rm i3/*.mconf

scripts: $(DEPS_SCRIPTS)
	find scripts -name "*.mconf" -exec sh -c 'mv "$$1" "${HOME}/.$${1%.mconf}"' _ {} \;
	chmod +x $(HOME)/.scripts/*.sh
	chmod +x $(HOME)/.scripts/*.py
	cp scripts/*.png $(HOME)/.scripts/

templates:
	cp -r templates/* $(HOME)/.templates/

polybar: polybar/config.mconf
	mv $< $(CONF)/polybar/config

termite: termite/config.mconf
	mv $< $(CONF)/termite/config

zsh: zsh/zshrc.mconf zsh/lambda.zsh-theme.mconf
	mv $< $(HOME)/.zshrc
	mv zsh/lambda.zsh-theme.mconf ${OHMYZSH}/themes/lambda.zsh-theme

vim: vim/vimrc.mconf
	mv $< $(HOME)/.vimrc

thunderbird:
	cp thunderbird/userChrome.css $(THUNDER)/*.default/chrome/userChrome.css
	cp thunderbird/rules.1und1.dat $(THUNDER)/*.default/ImapMail/imap.1und1.de/msgFilterRules.dat
	cp thunderbird/rules.tue.dat $(THUNDER)/*.default/ImapMail/webmail.tue.nl/msgFilterRules.dat

xbindkeys: xbindkeys/xbindkeysrc.mconf
	mv $< $(HOME)/.xbindkeysrc
	xbindkeys -p

ranger: ranger/rc.conf.mconf
	mv $< $(CONF)/ranger/rc.conf

ncmpcpp: ncmpcpp/bindings.mconf ncmpcpp/config.mconf
	mv ncmpcpp/bindings.mconf $(CONF)/ncmpcpp/bindings
	mv ncmpcpp/config.mconf $(CONF)/ncmpcpp/config

mpd: mpd/mpd.conf.mconf
	mv $< $(CONF)/mpd/mpd.conf

lightdm: lightdm/lightdm.conf.mconf lightdm/lightdm-webkit2-greeter.conf.mconf
	sudo mv lightdm/lightdm.conf.mconf $(LIGHTDM)/lightdm.conf
	sudo mv lightdm/lightdm-webkit2-greeter.conf.mconf $(LIGHTDM)/lightdm-webkit2-greeter.conf
	sudo cp -r lightdm/themes/sequoia /usr/share/lightdm-webkit/themes/
