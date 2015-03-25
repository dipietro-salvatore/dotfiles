#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=OneDrive
Exec=/opt/google/chrome/google-chrome "--app=https://onedrive.live.com/?cid=B580C5DF3BDA0958"
Icon=chrome-https___onedrive.live.com__cid=B580C5DF3BDA0958
StartupWMClass=onedrive.live.com
