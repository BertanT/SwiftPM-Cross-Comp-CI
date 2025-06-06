#!/bin/bash
#################################################################################################################################
# prep-release-notes.sh
# Created on 03/27/2025
#
# Copyright (C) 2025 Mehmet Bertan Tarakcioglu, Under the MIT License
#
# This file was originally created as part of the WatchDuck project CI Pipeline.
#################################################################################################################################

# This script is meant to run on a GitHub macOS Action Runner as part of the SwiftPM-Cross-Comp-CI workflows!
# It assumes to be part of the workflow and may fail if it is being run by itself.

# This script prepares release notes by extracting them from the changelog and obtaining tarball checksums.

# Exit bash script on error
set -e

# Extract release notes from the changelog and put them into RELEASE_NOTES.md
echo -e "## Release Notes" > RELEASE_NOTES.md
awk "/## \\[${NEW_TAG}\\]/{flag=1;next} /## \\[/&&flag{flag=0} flag" CHANGELOG.md | sed '/^\[.*\]: /d' >> RELEASE_NOTES.md

# Extract tarball checksums and append them into RELEASE_NOTES.md
echo -e "\n## SHA256 Checksums" >> RELEASE_NOTES.md
for file in .build/tarballs/*.sha256; do
    filename=$(basename "${file%.sha256}")
    checksum=$(awk '{print $1}' "${file}")
    echo "**${filename}**: ${checksum}" >> RELEASE_NOTES.md
done