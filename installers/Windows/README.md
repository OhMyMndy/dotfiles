# Windows installer

- Install chocolatey in admin powershell
`Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

- Right click "Merge" on Add_PS1_Run_as_administrator
- Run `Set-ExecutionPolicy Unrestricted` in an admin powershell

- Right click run as administrator on install.ps1
