# Driver Folder Organization

Standardizes known driver folder names. The default mode is a dry run; changes require an explicit apply flag.

Prerequisites: PowerShell or Bash 4+, plus write permission to the parent directory.

PowerShell dry run: `./standardize-driver-folders.ps1 -BasePath C:\path\to\drivers`

PowerShell apply: `./standardize-driver-folders.ps1 -BasePath C:\path\to\drivers -Apply`

Bash dry run: `./standardize-driver-folders.sh /path/to/drivers`

Bash apply: `APPLY_CHANGES=true ./standardize-driver-folders.sh /path/to/drivers`