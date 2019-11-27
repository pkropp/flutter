# mainly used https://flutter.dev/docs/get-started/install/macos

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
BASHPROFILEPATH := ~/.bash_profile

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

# FILE=BASHPROFILEPATH
# VARIABLE=`cat $(FILE)`
ifeq ($(findstring flutter,$(shell cat ~/.bash_profile)),flutter)
    # Found
    BASHPATHSET=true
else
    # Not found
    BASHPATHSET=false
endif

ifeq ($(findstring flutter,$(shell cat ~/.zshrc)),flutter)
    # Found
    ZSHPATHSET=true
else
    # Not found
    ZSHPATHSET=false
endif

flutter:
	make dependencies flutter-from-git pathneededcheck postinstall create
	#init add-path dependencies 
	#create-project

pathneededcheck:
	echo $(PATHSET)
	if $(PATHSET) == true; then echo "bash Pfad in ~/.bash_profile ist schon hinzugefügt"; else echo 'export PATH="$$PATH:$(shell echo $$PWD)/flutter/bin:$$HOME/.pub-cache/bin"' >> ~/.bash_profile; fi
	$(shell source ~/.bash_profile)

	echo $(ZSHPATHSET)
	if $(ZSHPATHSET) == true; then echo "zsh Pfad in ~/.zshrc ist schon hinzugefügt"; else echo 'export PATH="$$PATH:$(shell echo $$PWD)/flutter/bin:$$HOME/.pub-cache/bin"' >> ~/.zshrc; fi
	$(shell source ~/.zshrc)

flutter-from-git:
	@if [ -d "flutter" ]; then echo "flutter folder already there"; else git clone -b stable https://github.com/flutter/flutter.git; fi

flutter-master: # not the way it should be used as it seems
	@if [ -f "master.zip" ]; then echo "flutter master already there"; else wget https://github.com/flutter/flutter/archive/master.zip -P .; fi
	
	## @if [ -d "flutter" ]; then echo "flutter folder already there"; else unzip $(PWD)/flutter_macos_v1.9.1+hotfix.5-stable.zip; fi
	@if [ -d "flutter" ]; then echo "flutter folder already there"; else unzip $(PWD)/master.zip; fi
	@if [ -d "flutter-master" ]; then $(shell mv flutter-master flutter); else "flutter-master folder is already renamed"; fi

	# Error: The Flutter directory is not a clone of the GitHub project.
	#    The flutter tool requires Git in order to operate properly
	#    to set up Flutter, run the following command:
	#    git clone -b stable https://github.com/flutter/flutter.git

installcheck:
	@if command -v gem == ''; then echo "gem - already installed"; else echo "gem fehlt"; fi
	@if command -v brew == ''; then echo "brew - already installed"; else echo "brew fehlt"; fi
	@if command -v wget == ''; then echo "wget - already installed"; else echo "wget fehlt"; fi

init:

	# install homebrew if needed
	@if command -v brew == ''; then echo "brew - already installed"; else /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi
	
	# install wget if needed
	# if wget is installed (option for updating, but better do not change version):
	# brew upgrade wget
	@if command -v wget == ''; then echo "wget - already installed"; else brew install wget; fi
	
	# install gpg if needed
	@if command -v gpg == ''; then echo "wget - already installed"; else brew install gpg; fi

	# install rvm if no gem command existign (RubyGems is part of Ruby since Ruby 1.9)
	@if command -v gem == ''; then echo "gem - already installed"; else bash rvm-installer stable; fi

	# Upgrading the RVM installation in /Users/pk/.rvm/
    # RVM PATH line found in /Users/pk/.mkshrc /Users/pk/.profile /Users/pk/.bashrc.
    # RVM PATH line not found for Zsh, rerun this command with '--auto-dotfiles' flag to fix it.
    # RVM sourcing line found in /Users/pk/.profile /Users/pk/.bash_profile /Users/pk/.zlogin.
	# Upgrade of RVM in /Users/pk/.rvm/ is complete.
	
	# bash rvm-installer stable --auto-dotfiles

dependencies:
	# xcode for flutter
	sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
	sudo xcodebuild -runFirstLaunch
	sudo xcodebuild -license
	# open -a Simulator

postinstall:
	@if command -v flutter == ''; then flutter doctor; else echo "flutter not found"; fi

	flutter precache

	# how to check if existing?
	sudo gem install cocoapods
	#  1.7.3 nicht die aktuellste Version
	# intellij
	# ttps://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

	flutter doctor --android-licenses

# webconias-MBP:flutter pk$ make create-project
# Warning: Pub installs executables into $HOME/.pub-cache/bin, which is not on your path.
# You can fix that by adding this to your shell's config file (.bashrc, .bash_profile, etc.):

#   export PATH="$PATH":"$HOME/.pub-cache/bin"


# Doctor summary (to see all details, run flutter doctor -v):
# [✓] Flutter (Channel stable, v1.9.1+hotfix.6, on Mac OS X 10.14.6 18G1012, locale de-DE)
# [✗] Android toolchain - develop for Android devices
#     ✗ Unable to locate Android SDK.
#       Install Android Studio from: https://developer.android.com/studio/index.html
#       On first launch it will assist you in installing the Android SDK components.
#       (or visit https://flutter.dev/setup/#android-setup for detailed instructions).
#       If the Android SDK has been installed to a custom location, set ANDROID_HOME to that location.
#       You may also want to add it to your PATH environment variable.

# [!] Xcode - develop for iOS and macOS (Xcode 10.3)
#     ✗ CocoaPods not installed.
#         CocoaPods is used to retrieve the iOS and macOS platform side's plugin code that responds to your plugin usage on the Dart side.
#         Without CocoaPods, plugins will not work on iOS or macOS.
#         For more info, see https://flutter.dev/platform-plugins
#       To install:
#         sudo gem install cocoapods
# [!] Android Studio (not installed)
# [!] VS Code (version 1.40.1)
#     ✗ Flutter extension not installed; install from
#       https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
# [!] Connected device
#     ! No devices available

# ! Doctor found issues in 5 categories.



create:
	# needs sudo
	# $(shell echo "flutter pub global activate devtools")

	open -a Simulator
	
	@if [ -d "firstproject" ]; then $(shell echo "sh start_flutter.sh"); else flutter create firstproject; fi
	@if [ -d "firstproject" ]; then $(shell echo "sh start_flutter.sh"); else flutter create firstproject; fi


# webconias-MBP:flutter pk$ make create
# Warning: Pub installs executables into $HOME/.pub-cache/bin, which is not on your path.
# You can fix that by adding this to your shell's config file (.bashrc, .bash_profile, etc.):

#   export PATH="$PATH":"$HOME/.pub-cache/bin"

# make: execvp: ./firstproject: Permission denied
# Error: No pubspec.yaml file found.
# This command should be run from the root of your Flutter project.
# Do not run this command from the root of your git clone of Flutter.


