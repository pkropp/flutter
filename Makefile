#.EXPORT_ALL_VARIABLES:
#PATH="$(PATH):$(PWD)/flutter/bin"

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  flutter   download and install everything needed for flutter"
	@echo "  add-path  add downloaded flutter to path variables"
	@echo "  dependencies   install xcode"
	@echo "  create-project   create a project"

.PHONY: test

#PATHLINE := "$(shell head -2 ~/.bashrc)"
BASHPATHLINE := $(shell tail -n1 ~/.bashrc)

# @todo: find out how to handle zsh
ZSHPATHLINE := $(shell tail -n1 ~/.zshrc)
#PATHCHECK := "$(shell grep -i -e "PATH=" ~/.bashrc)"

# https://stackoverflow.com/questions/2741708/makefile-contains-string
ifeq ($(findstring flutter,$(BASHPATHLINE)),flutter)
    # Found
    RESULT=found
else
    # Not found
    RESULT=notfound
endif

flutter:
	make init add-path dependencies 
	#create-project

init:
	echo $(shell echo 'bash')
# used https://flutter.dev/docs/get-started/install/macos
	
	# install homebrew if needed
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	# install wget if needed
	brew install wget

	#[ -f $(PWD)/flutter_macos_v1.9.1+hotfix.5-stable.zip ] && echo "Found" || echo "not found"
	@wget https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.9.1+hotfix.5-stable.zip -P .

	#[ -d $(PWD)/flutter ] && echo "schon entpackt" || unzip $(PWD)/flutter_macos_v1.9.1+hotfix.5-stable.zip

	unzip $(PWD)/flutter_macos_v1.9.1+hotfix.5-stable.zip

	# alternative download to stay up to date
	#  https://github.com/flutter/flutter/archive/master.zip

add-path:
	echo ${RESULT}
	#.ONESHELL

# original export PATH="$PATH:$HOME/.rvm/bin"

## suggestion not use sed, because it is very slow https://stackoverflow.com/questions/4881930/remove-the-last-line-from-a-file-in-bash

ifeq ($(findstring notfound,$(RESULT)),notfound)
	echo "add the path"

	head -n 1 $(HOME)/.bashrc > .bashrc_temp
	echo '${TEST}'

	# shell command kills last character (which is an " doublequote) to have the option to add the new flutter path ending with needed doublequote
	echo '$(shell echo '$(BASHPATHLINE)' | rev | cut -c 2- | rev):$(PWD)/flutter/bin"' >> .bashrc_temp

	# backup existing shell config
	mv $(HOME)/.bashrc $(HOME)/.bashrc_backup
	# replace shell config with new generated file
	mv .bashrc_temp $(HOME)/.bashrc

	#$(SHELL) "source ~/.bashrc"

	echo $(shell echo "source ~/.bashrc")
else
	echo "leave it as is"
	#$(SHELL) "source ~/.bashrc"
	echo $(shell echo "source ~/.bashrc")
endif

dependencies:
	# xcode for flutter
	sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
	sudo xcodebuild -runFirstLaunch
	sudo xcodebuild -license
	open -a Simulator

create-project:
	#$(shell flutter pub global activate devtools)
	$(shell echo "bash")
	$(shell echo "flutter create firstproject")
	#cd firstproject
	#flutter run

