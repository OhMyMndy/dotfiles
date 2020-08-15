
mkdir -Force C:\cygwin64\etc

$terminalPath = (Get-Item "C:\users\Mandy\AppData\Local\Packages\Microsoft.WindowsTerminal*\" | Select-Object -Expand fullName)

New-Item -ItemType SymbolicLink -Path "C:\cygwin64\etc\nsswitch.conf" -Target "$PSScriptRoot\configs\etc\nsswitch.conf" -Force
New-Item -ItemType SymbolicLink -Path  "C:\users\Mandy\.inputrc" -Target "$PSScriptRoot\configs\.inputrc" -Force
New-Item -ItemType SymbolicLink -Path "$terminalPath\settings.json" -Target "$PSScriptRoot\configs\WindowsTerminal\settings.json" -Force
