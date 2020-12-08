# -*- mode: python -*-
# sepc file to freeze the application using pyinstaller

from pathlib import Path
import os
import sys
import importlib
import site
import pprint
pp = pprint.PrettyPrinter(indent=4)

block_cipher = None
added_files = []
name = "ctwUI"

# package_imports = [["PyQt5", ["QtWebEngineCore.pyi"]]]
# for package, files in package_imports:
#     proot = Path(importlib.import_module(package).__file__).parent
#     added_files.extend((proot / f, package) for f in files)

# add asset_dir
src_dir = "./src/"
asset_dirs = ["qml", "icons"]
asset_dirs = [os.path.join(src_dir, a) for a in asset_dirs]
for asset_dir in asset_dirs:
    asset_files = [
        f for f in os.listdir(asset_dir) if os.path.isfile(
            os.path.join(
                asset_dir, f))]
    for asset in asset_files:
        added_files.extend([(
            Path(os.path.abspath(os.path.join(asset_dir, asset))),
            Path(asset_dir)
        )])

# add qml
site_packages_dir = site.getsitepackages()[0]
# qml_dir = os.path.join(site_packages_dir, 'PyQt5', 'Qt', 'qml')
# rel_qml = os.path.relpath(qml_dir, start="./")
# added_files.extend([
#     (Path(os.path.abspath(os.path.join(qml_dir, 'QtQuick'))), Path(rel_qml)),
#     (Path(os.path.abspath(os.path.join(qml_dir, 'QtQuick.2'))), Path(rel_qml)),
#     (Path(os.path.abspath(os.path.join(qml_dir, 'QtWebEngine'))), Path(rel_qml)),
# ])


hidden = [
    # "PyQt5.QtWebEngineCore"
]

pp.pprint(added_files)
# print(added_files)
# print(os.path.abspath(src_dir))
# print(os.path.abspath(os.path.join(src_dir, "main.py")))
# exit()

a = Analysis([os.path.abspath(os.path.join(src_dir, "main.py"))],
             pathex=[os.path.abspath("./")],
             binaries=[],
             datas=added_files,
             hiddenimports=hidden,
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)

pyz = PYZ(a.pure, a.zipped_data,
          cipher=block_cipher)

if sys.platform == "darwin":
    exe = EXE(pyz,
            a.scripts,
            name=name,
            exclude_binaries=True,
            debug=False,
            bootloader_ignore_signals=False,
            strip=False,
            upx=True,
            runtime_tmpdir=None,
            console=False,
            icon=None
)
elif sys.platform == "win32" or sys.platform == "win64" or sys.platform == "linux":
    exe = EXE(pyz,
            a.scripts,
            # a.binaries,
            # a.zipfiles,
            # a.datas,
            name=name,
            exclude_binaries=True,
            debug=False,
            bootloader_ignore_signals=False,
            strip=False,
            upx=True,
            runtime_tmpdir=None,
            console=False,
            icon=None
)
else:
    print("No Target for ", sys.platform)
    sys.exit(1)

if sys.platform == "darwin":
    coll = COLLECT(exe,
            a.binaries,
            a.zipfiles,
            a.datas,
            strip=False,
            upx=True,
            upx_exclude=[],
            name=name
    )
    app = BUNDLE(exe,
                a.binaries,
                a.zipfiles,
                a.datas,
                 name="./../" + name + ".app",
                 info_plist={
                     "NSPrincipalClass": "NSApplication",
                     "NSHighResolutionCapable": "True",
                     "LSBackgroundOnly": "False",
                     "NSRequiresAquaSystemAppearance": "False"
                     # should be false to support dark mode
                     # known bug: https://github.com/pyinstaller/pyinstaller/issues/4615 with pyinstaller
                     # need to recompile pyinstaller with SDK >= 10.13
                 }
                 # icon=os.path.abspath(os.path.join(asset_dir, "icon-512.icns"))
                 )
elif sys.platform == "win32" or sys.platform == "win64":
    coll = COLLECT(exe,
                a.binaries,
                a.zipfiles,
                a.datas,
                strip=False,
                upx=True,
                upx_exclude=[],
                name=name
    )
