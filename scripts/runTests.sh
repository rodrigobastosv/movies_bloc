#!/bin/bash

cd ..
echo '############################### Cleaning stuff ###############################'
flutter clean
flutter pub get
flutter pub global activate remove_from_coverage
echo '############################### Running tests ################################'
flutter test --coverage
echo '############################### Removing unwanted files ######################'
flutter pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '.g.dart$' -r '.freezed.dart' -r '_state.dart' -r '_model.dart' -r '_dto.dart' -r 'locale_option.dart' -r 'lib/core/repository*'
echo '############################### Generating coverage ##########################'
genhtml coverage/lcov.info -o coverage/html
echo '############################### Opening coverage on Browser ##################'
google-chrome coverage/html/index.html &