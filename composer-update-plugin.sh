#!/bin/bash

################################################################################
# Update WordPress plugins that are included using composer.
#
# This script updates a list of plugins at once and creates a separate commit
# for each plugin that got update.
#
# Author: Sudar <http://sudarmuthu.com>
#
# License: Beerware ;)
#
# You should invoke this script from the Plugin directory, but you don't need
# to copy this script to every Plugin directory. You can just have one copy
# somewhere and then invoke it from multiple Plugin directories.
#
# Usage:
#  ./path/to/update-version.sh [plugin_name:x.x.x] [vendor/plugin_name:x.x.x]
#
# Refer to the README.md file for information about the different options
#
# Requires composer and git
#
################################################################################

while (( "$#" )); do
	package="$1"

	# If the package name doesn't include version then skip it.
	if [[ $package != *":"* ]]; then
		echo "$package doesn't have version. Skipping.."
		shift
		continue
	fi

	# If the package name doesn't include vendor prefix then assume it is wpackagist-plugin/
	if [[ $package != *"/"* ]]; then
		package="wpackagist-plugin/$1"
	fi

	# Update the package
	composer require $package

	plugin=${package%:*}
	plugin=${plugin#*/}
	version=${package#*:}

	git add composer.json composer.lock
	git commit -m "Update $plugin to v$version"
	shift
done
