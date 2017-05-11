#!/bin/bash

function backup_reports {
    backupDir="$1"
    fastlaneDir="$2"
    platform="$3"
    
    mkdir -p "$backupDir"

    reportFile="$fastlaneDir/report.xml"
    if [ -f "$reportFile" ]; then 
        cat "$reportFile" | sed "s|classname=\"fastlane\.lanes\"|classname=\"${platform}_fastlane\.lanes\"|g" > "$backupDir/${platform}_report.xml"
    fi

    testsReportFile="$fastlaneDir/test_output/report.junit"
    if [ -f "$testsReportFile" ]; then
        cp "$testsReportFile" "$backupDir/${platform}_tests_report.xml"
    fi
}

function clean_reports {
    fastlaneDir="$1"

    rm -f "$fastlaneDir/report.xml"
    rm -rf "$fastlaneDir/tests_output/"
}

