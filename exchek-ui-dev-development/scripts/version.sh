#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BRAND='\033[38;2;255;82;0m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[Version Update]${NC} $1"
}

print_error() {
    echo -e "${RED}[Error]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[Warning]${NC} $1"
}
print_branding() {
    echo -e "${BRAND}${NC} $1"
}

# Function to validate version format
validate_version() {
    if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Use X.Y.Z format (e.g., 1.0.0)"
        exit 1
    fi
}

# Function to validate build number
validate_build_number() {
    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        print_error "Invalid build number. Use a positive integer"
        exit 1
    fi
}

# Function to get current date and time
get_current_datetime() {
    date "+%Y-%m-%d %H:%M:%S"
}

# Function to get current date
get_current_date() {
    date "+%Y-%m-%d"
}

# Function to get day name
get_day_name() {
    date "+%A"
}

# Function to get changes from user
get_changes() {  
    local changes=""
    local line
    local empty_lines=0
    
    while IFS= read -r line; do
        if [ -z "$line" ]; then
            empty_lines=$((empty_lines + 1))
            if [ $empty_lines -eq 2 ]; then
                break
            fi
        else
            empty_lines=0
            # Make sure each line starts with "- "
            if [[ ! $line =~ ^-\ .* ]]; then
                if [[ $line =~ ^-.* ]]; then
                    # Add a space after the dash if it's missing
                    line="${line:0:1} ${line:1}"
                else
                    # Add "- " prefix if missing entirely
                    line="- $line"
                fi
            fi
            changes+="$line\n"
        fi
    done
    
    if [ -z "$changes" ]; then
        changes="- No changes specified\n"
    fi
    
    # Return just the cleaned changes text without any terminal formatting
    echo -e "$changes"
}

# Function to update changelog - MODIFIED to always add a new entry with proper formatting
update_changelog() {
    local version=$1
    local build_number=$2
    local changelog_file="CHANGELOG.md"
    
    # Get current date, time and day
    local current_date=$(get_current_date)
    local current_datetime=$(get_current_datetime)
    local day_name=$(get_day_name)
    
    # Get changes from user (just the clean text)
    local changes=$(get_changes)
    
    # Create new changelog entry with proper spacing and formatting
    local changelog_entry="## [$version] - $current_date ($day_name)
- Build number: $build_number
- Timestamp: $current_datetime
### Changes
$changes"
    
    # If changelog doesn't exist, create it with header
    if [ ! -f "$changelog_file" ]; then
        echo -e "# Changelog\n\nAll notable changes to this project will be documented in this file.\n\n$changelog_entry" > "$changelog_file"
        print_branding "✅ Created new CHANGELOG.md with version $version (build $build_number)"
        return
    fi
    
    # Always insert a new entry at the top, after the header
    local temp_file=$(mktemp)
    
    # Extract header (everything before the first version entry)
    awk '/^## \[/{exit} {print}' "$changelog_file" > "$temp_file"
    
    # Add the new version entry
    echo -e "$changelog_entry\n\n" >> "$temp_file"
    
    # Append the rest of the versions
    awk '/^## \[/{p=1} p{print}' "$changelog_file" >> "$temp_file"
    
    # Replace the original file with the temporary file
    mv "$temp_file" "$changelog_file"
    
    print_branding "✅  Added new entry for version $version (build $build_number) to CHANGELOG.md"
}

# Function to update pubspec.yaml
update_pubspec() {
    local version=$1
    local build_number=$2
    local pubspec_file="pubspec.yaml"
    
    if [ ! -f "$pubspec_file" ]; then
        print_error "pubspec.yaml not found"
        exit 1
    fi
    
    # Update version in pubspec.yaml
    sed -i '' "s/version: .*/version: $version+$build_number/" "$pubspec_file"
    print_branding "✅ Updated pubspec.yaml to version $version+$build_number"
}

# Function to update Android version
update_android() {
    local version=$1
    local build_number=$2
    local gradle_file="android/app/build.gradle.kts"
    
    if [ ! -f "$gradle_file" ]; then
        print_warning "Android build.gradle.kts not found"
        return
    fi
    
    # Update versionName and versionCode in Kotlin DSL format
    sed -i '' "s/versionName = \".*\"/versionName = \"$version\"/" "$gradle_file"
    sed -i '' "s/versionCode = [0-9]*/versionCode = $build_number/" "$gradle_file"
    print_branding "✅  Updated Android version to $version (build $build_number)"
}

# Function to update iOS version
update_ios() {
    local version=$1
    local build_number=$2
    local project_file="ios/Runner.xcodeproj/project.pbxproj"
    local info_plist="ios/Runner/Info.plist"
    
    if [ ! -f "$project_file" ]; then
        print_warning "iOS project.pbxproj not found"
        return
    fi
    
    if [ ! -f "$info_plist" ]; then
        print_warning "iOS Info.plist not found"
        return
    fi
    
    # Update MARKETING_VERSION and CURRENT_PROJECT_VERSION in project.pbxproj
    sed -i '' "s/MARKETING_VERSION = [0-9.]*;/MARKETING_VERSION = $version;/" "$project_file"
    sed -i '' "s/CURRENT_PROJECT_VERSION = [0-9]*;/CURRENT_PROJECT_VERSION = $build_number;/" "$project_file"
    
    # Update CFBundleShortVersionString and CFBundleVersion in Info.plist
    # Using a more precise pattern to match and replace the entire key-value pair
    sed -i '' "/<key>CFBundleShortVersionString<\/key>/,/<string>.*<\/string>/s/<string>.*<\/string>/<string>$version<\/string>/" "$info_plist"
    sed -i '' "/<key>CFBundleVersion<\/key>/,/<string>.*<\/string>/s/<string>.*<\/string>/<string>$build_number<\/string>/" "$info_plist"
    
    print_branding "✅  Updated iOS version to $version (build $build_number)"
}

# Main script
if [ "$#" -lt 2 ]; then
    print_error "Usage: $0 <version> <build_number>"
    print_error "Example: $0 1.0.0 1"
    exit 1
fi

VERSION=$1
BUILD_NUMBER=$2

# Validate inputs
validate_version "$VERSION"
validate_build_number "$BUILD_NUMBER"

# Update versions
print_branding "⌛ Starting version update process..."
update_changelog "$VERSION" "$BUILD_NUMBER"
update_pubspec "$VERSION" "$BUILD_NUMBER"
update_android "$VERSION" "$BUILD_NUMBER"
update_ios "$VERSION" "$BUILD_NUMBER"


print_branding "🎉Version update completed successfully!"