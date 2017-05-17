#!/bin/bash

function updateBrewPackage {
    package="$1"

    if brew ls --versions "$package" > /dev/null; then
        brew upgrade -v "$package"

    else
        brew install -v "$package"

    fi
}

echo -e "${GREEN}Updating tools...${NC}"

brew update -v
updateBrewPackage ruby
updateBrewPackage swiftlint
updateBrewPackage mogenerator

sudo gem update --no-document -n /usr/local/bin --verbose cocoapods fastlane
sudo gem cleanup

pod repo update
