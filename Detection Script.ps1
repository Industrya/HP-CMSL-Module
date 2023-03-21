# HP Dock Firmware Version check
$LatestFirmwareVersion = "1.0.16.0"

try {
	$namespace = "ROOT\HP\InstrumentedServices\v1"
	$classname = "HP_DockAccessory"
	$DockWMIobj = Get-WmiObject -Class $classname -Namespace $namespace
} catch {
	Write-Output "Unable to retrieve HP Dock Firmware Version" ; exit 0
}

if ($DockWMIobj.FirmwarePackageVersion -lt $LatestFirmwareVersion) {
	Write-Output "Docking station does not have latest available Firmware version installed"; exit 1
} elseif ($DockWMIobj.FirmwarePackageVersion -eq $LatestFirmwareVersion) {
	Write-Output "Docking station has latest available Firmware version installed."; exit 0
} else {
	Write-Output "Unknown exception occured"; exit 0
}