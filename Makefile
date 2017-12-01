GIT := $(HOME)/git/arch
CONF := $(HOME)/.config
OHMYZSH := $(HOME)/.oh-my-zsh

SOURCES_I3 := $(shell find i3 -type f -name "*.conf")

DEPS_I3 := $(SOURCES_I3:%=%.mconf)

.PHONY: all templates thunderbird
all: alias i3 polybar termite zsh vim

%.mconf:
	./configParser.sh $(@:%.mconf=%) $@

i3: $(DEPS_I3)
	[[ -f $(CONF)/i3/config ]] && rm $(CONF)/i3/config
	cat i3/*.mconf >> $(CONF)/i3/config
	rm i3/*.mconf

polybar: polybar/config.mconf
	mv $< $(CONF)/polybar/config

termite: termite/config.mconf
	mv $< $(CONF)/termite/config

zsh: zsh/zshrc.mconf zsh/lambda.zsh-theme.mconf
	mv $< $(HOME)/.zshrc
	mv zsh/lambda.zsh-theme.mconf ${OHMYZSH}/themes/lambda.zsh-theme

vim: vim/vimrc.mconf
	mv $< $(HOME)/.vimrc
