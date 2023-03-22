$TempDir = [System.IO.Path]::GetTempPath()

New-Item -ItemType Directory -Force -Path "$TempDir\HP"
cd "$TempDir\HP"

if (-not (Test-Path -path "C:\Program Files\HP\HP Firmware Installer\HP USB-C Dock G5")) {
Get-Softpaq -number 143343 -Extract -DestinationPath "c:\SWsetup\SP143343" -verbose
msiexec /i "C:\SWSetup\SP143343\Manageability\HPFirmwareInstaller64.msi" /qn /L*v C:\swsetup\dock.log
} else{
    write-output "Path exists"
}

cd "C:\SWsetup\SP143343"
.\HPFirmwareInstaller.exe -stage -silent
