#!/bin/dash

# ------------ SET -------------

ID="floorp"; Path="$HOME/.local/share/floorp"; Exec="$Path/$ID"; Binary="$HOME/.local/bin/$ID"; Tarball=$(mktemp /tmp/$ID.XXXXXX.tar.bz2)
Version=$(curl -s https://github.com/Floorp-Projects/Floorp/tags | grep -m 1 '<h2 data-view-component="true" class="f4 d-inline">' | grep -o -P '(?<=Link">v).*(?=</a></h2>)')
URL="https://github.com/Floorp-Projects/Floorp/releases/download/v$Version/$ID-$Version.linux-x86_64.tar.bz2"
XDG_Desktop_Entry="$HOME/.local/applications/$ID.desktop"

# ----------- CHECK ------------

clear; printf "\n[Floorp Install Tool]\n"

if [ -f "$Binary" ]; then
  printf "[X] Removing already existing binary\n"; rm "$Binary"
fi

if [ -d "$Path" ]; then
  printf "[X] Removing already existing version\n"; rm -rf "$Path"
fi

if [ -f "$XDG_Desktop_Entry" ]; then
  printf "[X] Removing already existing desktop entry\n"; rm "$XDG_Desktop_Entry"
fi

mkdir -p $HOME/.local/applications/
mkdir -p $HOME/.local/bin/
mkdir -p $HOME/.local/share/

# ---------- DOWNLOAD -----------

printf "\n[*] Downloading $ID v$Version (Wait until it's finished)"; curl -L -s -o $Tarball $URL

# ---------- INSTALL ------------

printf "\n[*] Extracting tarball\n"; tar -xjf $Tarball; mv $ID $Path 2>/dev/null; rm $Tarball

# ---------- SHORTCUT -----------

touch $Binary; chmod +x $Binary
touch $XDG_Desktop_Entry

printf '%s\n' '#!/bin/sh' $Exec >> $Binary && printf "\n[*] Shortcut created at: $Binary"
printf '%s\n'	'[Desktop Entry]' 'Type=Application' 'Version='$Version'' 'Name='$ID'' 'GenericName=Web Browser' \
				'Icon='$Path/'browser/chrome/icons/default/default128.png' 'Exec='$ID' %u' 'Path='$Path/'' 'Terminal=false' \
				'MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;' \
				'Categories=Network;WebBrowser;' 'Keywords=web;browser;internet' >> $XDG_Desktop_Entry && printf "\n[*] Shortcut created at: $XDG_Desktop_Entry\n\n"
exit #EOF
