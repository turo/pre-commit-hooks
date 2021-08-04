# -*- mode: python -*-

block_cipher = None

a = Analysis(['/usr/local/bin/pre-commit'],
             pathex=['.'],
             datas=[('pre_commit/resources/*', 'resources')],
             hiddenimports=[],
             hookspath=None,
             runtime_hooks=None,
             cipher=block_cipher)

pyz = PYZ(a.pure, cipher=block_cipher)

exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='pre-commit',
          debug=False,
          strip=None,
          upx=True,
          console=True,
          bootloader_ignore_signals=True)
