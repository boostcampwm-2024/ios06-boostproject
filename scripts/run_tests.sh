#!/bin/bash
SCHEME='Molio'
DESTINATION='platform=iOS Simulator,OS=17.0.1,name=iPhone 15 Pro'
# DESTINATION='platform=iOS Simulator,OS=18.0,name=iPhone 16 Pro' # 로컬용
xcodebuild clean test \
    -scheme $SCHEME \
    -sdk iphonesimulator \
    -destination "$DESTINATION" \
    -skipPackagePluginValidation \
    CODE_SIGNING_ALLOWED='NO' | xcpretty --simple --color
