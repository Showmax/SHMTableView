#!/bin/bash

source /etc/profile
export FASTLANE_DISABLE_COLORS=1
export LANG=en_US.UTF-8

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update Fastlane
cd "$scriptDir"
bash update_tools.sh

source ./prepare_reports.sh

# Run Fastlane lane for continuous integration
fastlane ios tests_distrib_ios
ciIOSBasicResultCode=$?

backup_reports "../reports/" "fastlane" "ios"
clean_reports "fastlane"

fastlane ios tests_distrib_tvos
ciTVOSBasicResultCode=$?

backup_reports "../reports/" "fastlane" "tvos"

echo "Done."

if [ $ciIOSBasicResultCode -ne 0 ] || [ $ciTVOSBasicResultCode -ne 0 ]; then
    exit 1
else
    exit 0
fi

