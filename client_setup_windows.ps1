echo "checking admin..."
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments -WorkingDirectory (Get-Item -Path ".\" -Verbose).FullName
Break
}

cd $PSScriptRoot

Add-Type -assembly "system.io.compression.filesystem"

$appname = "NVB"
md $("C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\" + $appname)

function CreateShortcut($target, $arguments = "", $shortcutName = "", $workingDir = ""){
    if ($workingDir -eq ""){
	    $workingDir = $(Path-Split $target)
	}
	$objShell = New-Object -ComObject ("WScript.Shell")
	$objShortCut = $objShell.CreateShortcut("C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\" + $appname + "\" + $shortcutName + ".lnk")
	$objShortCut.TargetPath = $target
	$objShortCut.Arguments = $arguments
	$objShortCut.WorkingDirectory = $workingDir
	$objShortCut.Save()
}

echo "Installing Python..."
start "msiexec.exe" "/i","python-3.4.3.msi","/passive" -Wait
echo "Installing requirements through pip"
$env:Path += ";C:\Python34\;C:\Python34\Scripts\"
pip install cryptography zope.interface sqlalchemy

# download and install dependencies

$zips=@(
    ,@("https://github.com/richardkiss/pycoin/archive/master.zip", "pycoin-master")
	,@("https://github.com/XertroV/nvblib/archive/master.zip","nvblib-master")
	,@("https://github.com/XertroV/nvbclient/archive/master.zip","nvbclient-master")
	,@("https://github.com/XertroV/nvbtally/archive/master.zip","nvbtally-master")
	)

foreach($arr in $zips) {
    echo "!! Downloading and installing $($arr[1])"
	wget $arr[0] -OutFile $($arr[1]+".zip")
	[io.compression.zipfile]::ExtractToDirectory(".\"+$arr[1]+".zip",".\")
	cd $arr[1]
	python setup.py install
	cd ".."
	rm $($arr[1]+".zip")
}

# set up databases & shortcuts
echo "Setting up DBs and shortcuts"

cd "nvbclient-master"
echo "You will need to enter a password for the NVB client shortly..."
mv "nvb-client.sqlite" $("nvb-client.sqlite.bak." + $(date -Format "yyyyMMddHHmmss"))
initialize_nvb_client_db.exe production.ini
CreateShortcut "c:\python34\scripts\pserve.exe" -arguments ((Get-Item -Path ".\" -Verbose).FullName + "\production.ini") -shortcutName "Start NVB Client" -workingDir (Get-Item -Path ".\" -Verbose).FullName
cd ".."
echo "NVB Client setup complete"

cd "nvbtally-master"
CreateShortcut "c:\python34\scripts\pserve.exe" -arguments ((Get-Item -Path ".\" -Verbose).FullName + "\development.ini") -shortcutName "Start NVB Tally GUI" -workingDir (Get-Item -Path ".\" -Verbose).FullName
CreateShortcut "c:\python34\python.exe" "-m nvbtally.sync_all" "Sync NVB Tally DB" -workingDir (Get-Item -Path ".\" -Verbose).FullName
cd ".."
echo "NVB Tally setup complete"


Read-Host "!! Installation done! Press ENTER to continue"
