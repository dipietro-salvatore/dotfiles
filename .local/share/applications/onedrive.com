#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=OneDrive
Exec=/opt/google/chrome/google-chrome "--app=https://onedrive.live.com/?cid=B580C5DF3BDA0958"
Icon=onedrive.ico
StartupWMClass=onedrive.live.com
