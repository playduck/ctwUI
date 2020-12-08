$name = "ctwUI"
$build = ".\build"
$dist = ".\dist"
$spec = ".\tools\build.spec"
$flags = $("--clean --noconfirm --onedir --windowed --name $name --distpath $dist --workpath $build")

$command = $(".\venv\Scripts\Activate.ps1; pyinstaller $flags $spec")
$remove = $("-rmdir $build -r -fo; rmdir $dist -r -fo")

Invoke-Expression $("$remove")
Invoke-Expression $command
