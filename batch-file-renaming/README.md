# Batch File Renaming

Generates names in the format `ABC-DEF-001-RANDOMID-YYYYMMDD.extension`. The default mode is a dry run.

Prerequisites: PowerShell or Bash with permission to rename files.

PowerShell dry run: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper`

PowerShell apply: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper -Apply`

Bash dry run: `./rename-files.sh /path/to/files mobile wallpaper`

Bash apply: `APPLY_CHANGES=true ./rename-files.sh /path/to/files mobile wallpaper`