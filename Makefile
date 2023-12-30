USER_NAME = $(shell python3 scripts/author_name.py)
CURRENT_DATE = $(shell pipenv run python scripts/current_date.py)
	
feature:
	@tuist scaffold Feature \
	 --name ${name} \
	 --author "$(USER_NAME)" \
	 --current-date "$(CURRENT_DATE)"
	 
	@tuist edit
	
library:
	@tuist scaffold Library \
	 --name ${name} \
	 
	@tuist edit

generate:
	defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
	tuist clean
	tuist fetch
	tuist generate

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
