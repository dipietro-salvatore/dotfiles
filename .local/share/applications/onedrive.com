#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=OneDrive
Exec=/opt/google/chrome/google-chrome "--app=https://onedrive.live.com/"
Icon=onedrive.ico
StartupWMClass=onedrive.live.com
