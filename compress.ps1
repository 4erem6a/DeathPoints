param(
  [parameter(Mandatory = $false)][string] $outDir = "$($Env:APPDATA)/Factorio/mods",
  [parameter(Mandatory = $false)][string] $modDir = ".",
  [parameter(Mandatory = $false)][string] $infoPath = "$modDir/info.json"
)

$info = Get-Content $infoPath | ConvertFrom-Json

Compress-Archive $modDir "$outDir/$($info.name)_$($info.version).zip" -Force