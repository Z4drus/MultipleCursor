# Cursor Profile Launcher

A utility that enables running multiple instances of Cursor IDE simultaneously, allowing you to edit the same codebase from different Cursor windows.

## Overview

The Cursor Profile Launcher creates isolated Cursor profiles, each with its own user data directory. This separation allows multiple Cursor instances to run concurrently without conflicting, even when opening the same project.

## Benefits

- **Multiple Cursors on One Codebase**: Edit different parts of your project simultaneously
- **Parallel AI Assistance**: Run multiple AI conversations about different parts of your codebase
- **Context Separation**: Keep unrelated work in separate instances
- **Resource Management**: Configure memory limits for each instance separately

## Usage

1. Run `cursor-launcher.bat`
2. Choose a profile option:
   - Select a numbered profile (1-4)
   - Or create a custom named profile
3. Optionally specify:
   - Project directory to open
   - Memory limit (default 16GB)

## Example Use Cases

- Working on frontend and backend components simultaneously
- Running long AI analysis in one instance while actively coding in another
- Testing different AI approaches to the same problem
- Comparing different versions of the same file

## Technical Details

The launcher works by using Cursor's `--user-data-dir` flag to create isolated environments for each instance. Each profile maintains its own:

- Extension configurations
- Window layouts
- Session history
- AI conversation history

This approach ensures that multiple Cursor instances can operate independently while allowing you to view and edit the same files. 