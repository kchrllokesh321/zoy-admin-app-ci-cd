# Liquor Express App - Version Management Guide

## Introduction
This guide explains how we manage app versions and updates in the Liquor Express application. We have created a simple system that helps us keep track of all changes and maintain consistent version numbers across different platforms (iOS and Android).

## What is Version Management?
Version management is like keeping a detailed diary of all the changes we make to the app. Each time we make updates, we:
1. Assign a new version number
2. Record what changes were made
3. Update all necessary files automatically

## How to Use the Version Update Script

### Basic Requirements
- A Mac computer
- Terminal application
- Access to the project folder

### Steps to Update Version

1. **Open Terminal**
   - Press Command + Space
   - Type "Terminal" and press Enter

2. **Navigate to Project**
   - Type: `cd /path/to/exchek`
   - Press Enter

3. **Run the Version Update Script**
   - Type: `./scripts/version.sh 1.0.0 1`
   - Replace `1.0.0` with your desired version number
   - Replace `1` with your build number
   - Press Enter

4. **Enter Changes**
   - The script will ask you to describe what changes were made
   - Type each change and press Enter
   - Press Enter twice when done

### Version Number Format
- Use format: X.Y.Z (e.g., 1.0.0)
  - X: Major changes (big updates)
  - Y: Minor changes (small updates)
  - Z: Bug fixes

### What the Script Does
1. Updates version numbers in:
   - iOS app settings
   - Android app settings
   - App configuration files
2. Creates/updates a changelog (CHANGELOG.md)
3. Records:
   - Version number
   - Build number
   - Date and time
   - List of changes

### Example
```
./scripts/version.sh 1.1.0 2
```
This will:
- Set version to 1.1.0
- Set build number to 2
- Prompt for changes
- Update all necessary files

## Benefits
1. **Consistency**: All version numbers stay in sync
2. **Tracking**: Easy to see what changed and when
3. **Organization**: Clear history of app updates
4. **Automation**: Reduces manual work and errors

## Support
If you need help using the version management system, please contact the development team.

---
*This guide is designed to help team members understand and use our version management system effectively.* 