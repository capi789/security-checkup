#!/bin/zsh
# Security Checkup for Mac. Read-only: it only LOOKS, it changes nothing and sends nothing anywhere.
# Run:  zsh check-my-mac.sh
G=$'\e[32m'; R=$'\e[31m'; Y=$'\e[33m'; B=$'\e[1m'; N=$'\e[0m'
fix=0
ok(){ print "${G}✔${N} $1"; }
bad(){ print "${R}✘ $1${N}\n    ${Y}Fix:${N} $2"; fix=$((fix+1)); }
warn(){ print "${Y}! $1${N}\n    ${Y}Check:${N} $2"; }
print "${B}Mac Security Checkup${N} ($(date '+%b %d %Y'))\n"

# 1 Updates
pend=$(softwareupdate -l 2>&1 | grep -E '^\s*\* Label' | sed 's/.*Label: //')
[[ -z $pend ]] && ok "macOS is up to date" || bad "Updates waiting: $(echo $pend | tr '\n' ',' | sed 's/,$//')" "System Settings > General > Software Update > Update Now."
au=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall 2>/dev/null)
[[ $au == 1 ]] && ok "Security updates install automatically" || bad "Automatic security updates are off" "System Settings > General > Software Update > Automatic Updates > turn everything on."

# 2 Disk encryption
fdesetup status | grep -q "On" && ok "FileVault (disk encryption) is on" || bad "FileVault is OFF: anyone who steals the Mac can read your files" "System Settings > Privacy & Security > FileVault > Turn On."

# 3 Firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -q enabled && ok "Firewall is on" || bad "Firewall is OFF: other devices on the same Wi-Fi can reach apps on this Mac" "System Settings > Network > Firewall > turn On. Then Options > turn on 'Enable stealth mode'."

# 4 Built-in protections
csrutil status | grep -q enabled && ok "System Integrity Protection is on" || bad "System Integrity Protection is off" "Ask a tech-savvy friend to re-enable it from Recovery mode (csrutil enable)."
spctl --status 2>/dev/null | grep -q enabled && ok "Gatekeeper (blocks unknown apps) is on" || bad "Gatekeeper is off" "Terminal: sudo spctl --master-enable"

# 5 Screen lock
d=$(sysadminctl -screenLock status 2>&1 | grep -o 'delay is.*' )
[[ $d == *immediate* || $d == *"5 seconds"* ]] && ok "Password is needed right after sleep/screensaver" || bad "Screen lock delay: ${d:-unknown}" "System Settings > Lock Screen > 'Require password after screen saver begins' > Immediately."

# 6 Guest + sharing
[[ $(defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled 2>/dev/null) == 1 ]] && bad "Guest user is on" "System Settings > Users & Groups > Guest User > off." || ok "Guest user is off"
for svc in screensharing:"Screen Sharing" smbd:"File Sharing" ARDAgent:"Remote Management"; do
  launchctl print system/com.apple.${svc%%:*} >/dev/null 2>&1 && warn "${svc#*:} is on" "Only keep it if you use it: System Settings > General > Sharing."
done

# 7 Apps open to the network
open=$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 && ($9 ~ /^\*:/ || $9 ~ /^0\.0\.0\.0/){split($9,a,":"); print $1" (port "a[length(a)]")"}' | grep -vE 'rapportd|ControlCe' | sort -u)
[[ -z $open ]] && ok "No apps are open to other devices on your network" || warn "These apps accept connections from other devices on your Wi-Fi:\n      $(echo $open | tr '\n' ' ')" "If you don't know what one is, quit it. Turning the firewall on (step 3) blocks most of this."
lsof -nP -iTCP:7000 -sTCP:LISTEN >/dev/null 2>&1 && warn "AirPlay Receiver is on (anyone nearby can try to cast to this Mac)" "System Settings > General > AirDrop & Handoff > AirPlay Receiver > off, or 'Current User'."

# 8 Secrets left lying around
PAT='(sk-[A-Za-z0-9]{20,}|sk_live_[A-Za-z0-9]{10,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|xox[bp]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY)'
hits=$(grep -rIlE "$PAT" ~/Desktop ~/Documents ~/Downloads --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=site-packages --exclude-dir=python-deps --exclude-dir=.venv --exclude-dir=venv --exclude-dir=dist --exclude-dir=build --exclude-dir=Library --include="*.txt" --include="*.md" --include="*.rtf" --include="*.csv" --include="*.json" --include="*.env" --include=".env*" --include="*.pem" --include="*.key" 2>/dev/null | head -10)
[[ -z $hits ]] && ok "No API keys or private keys found sitting in Desktop/Documents/Downloads" || bad "Possible keys/secrets in plain files:\n      $(echo $hits | sed "s|$HOME|~|g" | tr '\n' ' ')" "Move each secret into a password manager (or Keychain) and delete the file."
pw=$(find ~/Desktop ~/Documents ~/Downloads -maxdepth 3 -type f \( -name '*.txt' -o -name '*.rtf' -o -name '*.csv' -o -name '*.md' \) -not -path '*/.*' -not -path '*/node_modules/*' 2>/dev/null | xargs -I{} grep -lEi '^[[:space:]]*[-*]?[[:space:]]*(my[[:space:]]+)?(password|passcode|pw|pass)[[:space:]]*[:=][[:space:]]*[^[:space:]<{]{6,}' {} 2>/dev/null | head -10)
[[ -n $pw ]] && warn "Files that look like they hold passwords:\n      $(echo $pw | sed "s|$HOME|~|g" | tr '\n' ' ')" "Passwords belong in a password manager (Apple Passwords app is free), not in notes or text files."
hist=$(grep -ciE "$PAT|password=|passwd|token=" ~/.zsh_history ~/.bash_history 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
[[ $hist -gt 0 ]] && bad "$hist line(s) in your Terminal history look like passwords or keys" "Rotate those keys, then clear history: rm ~/.zsh_history" || ok "Terminal history has no obvious secrets"

# 9 SSH keys
for k in ~/.ssh/*(N); do [[ $k == *.pub || $k == *known_hosts* || $k == *config ]] && continue; p=$(stat -f %Lp "$k"); [[ $p != 600 && $p != 400 ]] && bad "SSH key $k can be read by other users ($p)" "chmod 600 $k"; done

print "\n${B}Done.${N} $([[ $fix -eq 0 ]] && echo "${G}Nothing urgent to fix.${N}" || echo "${R}$fix thing(s) to fix above.${N}")"
print "Next: open CHECKLIST.md for your phone, email, bank and carrier steps (the Mac can't check those for you)."
