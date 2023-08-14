# run this command if no execution policy error: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Util function 
function Write-Start {
	param ($msg)
	Write-Host (">>>"+$msg) - ForegroundColor Yellow
}

function Write-Done { Write-Host "done" -ForegroundColor Green; Write-Host }

# Start process
Start-Process -Wait powershell -verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -name ConsentPromptBehaviorAdmin -Value 0"

Write-Start -msg "Installing Scoop just a minus...."
if (Get-Command scoop -errorAction SilentlyContinue)
{
	Write-Warning "Scoop already in this machine"
}
else {
	Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
	irm get.scoop.sh | iex
}
Write-Done

Write-Start -msg "Initializing Scoop..."
	scoop install git
	scoop bucket add extras
	scoop bucket add nerd-fonts
	scoop bucket add nonportable
	scoop bucket add main
	scoop update
Write-Done

Write-Start -msg "Installing optional Scoop's Packages"
	scoop install <# Browser #> googlechrome
	scoop install <# code Editor #> vscode python
	scoop install <# video player #> k-lite-codec-pack-mega-np
	scoop install <# compress and extract file #> 7zip
	scoop install <# modern content menu #> nilesoft-shell
	scoop install <# edit text file #> sublime-text
Write-Done -msg "Install completed.."

Write-Start -msg "Download and install font and Visual C++...."
	Start-Process -Wait powershell -verb runas -ArgumentList "scoop install Cascadia-Code FiraCode vcredist-aio "
Write-Done -msg "Install completed..."

Write-Start -msg "Configuring VSCode just a minus...."
	<# apply setting and keybinding for user #>

	$DestinationPath = "~\Appdata\Roaming\Code\User"
	If (-not (Test-Path $DestinationPath)) {
		New-Item -ItemType File -Path $DestinationPath -Force
	}
	Copy-Item ".\config\vscode\keybindings.json" -Destination $DestinationPath -Force
	Copy-Item ".\config\vscode\settings.json" -Destination $DestinationPath -Force
Write-Done -msg "Configure completed.."

Write-Start -msg "Configuring Visual Studio Code Extensions...."
	<# code with python #>
	code --install-extension ms-python.vscode-pylance.vsix
	code --install-extension ms-python.python.vsix
	code --install-extension kevinrose.vsc-python-indent.vsix

	<# code with AI #>
	code --install-extension Codeium.codeium.vsix


	<# check error for code #>
	code --install-extension usernamehw.errorlens.vsix


	<# theme and icon file #>
	code --install-extension vscode-icons-team.vscode-icons.vsix
	code --install-extension miguelsolorio.fluent-icons.vsix
	code --install-extension eliverlara.andromeda.vsix


	<# code with html #>
	code --install-extension formulahendry.auto-rename-tag.vsix
	code --install-extension formulahendry.code-runner.vsix
	code --install-extension adpyke.codesnap.vsix
	code --install-extension sidthesloth.html5-boilerplate.vsix
	code --install-extension anderseandersen.html-class-suggestions.vsix
	code --install-extension ecmel.vscode-html-css.vsix
	code --install-extension zignd.html-css-class-completion.vsix
	code --install-extension ritwickdey.liveserver.vsix
	code --install-extension daiyy.quick-html-previewer.vsix

	<# auto complete code #>
	code --install-extension visualstudioexptteam.vscodeintellicode-completions.vsix


	<# speed code typing #> 
	code --install-extension tesoro.schedoost.vsix
Write-Done


Write-Start -msg "Configuring Wallpapers...."
	Start-Process -Wait powershell -verb runas -AgrumentList "Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value .\config\wallpapers\picture1.jpg
    rundll32.exe user32.dll, UpdatePerUserSystemParameters"
Write-Done

Write-Start -msg "Disable Unused Features and Remove junkfile"
	Start-Process -Wait powershell -verb runas -ArgumentList @"
		echo y | Disable-WindowsOptionalFeature -Online -FeatureName Printing-PrintToPDFServices-Features

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName Printing-XPSServices-Features

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName  LegacyComponents

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

		echo y | Disable-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64
    
    	echo y | Disable-WindowsErrorReporting

    	echo y | Disable-BitLocker

    	echo y | Delete-DeliveryOptimizationCache

	"@
Write-Done

Write-Start -msg "Complete Setup and Configure machine..."
Write-Done
