# Security Checkup

A free, 15-minute self-checkup that closes the ways normal people actually get hacked.

**1. Mac checkup (automatic, read-only).** Download `check-my-mac.sh`, open Terminal, and run:
```
zsh ~/Downloads/check-my-mac.sh
```
You get a ✔ / ✘ list in plain English with the exact setting to change for each ✘. It does not change anything, needs no password, and sends nothing over the internet.

**2. Everything else (phone, email, bank, carrier).** Open [CHECKLIST.md](CHECKLIST.md) and tick the boxes top to bottom.

What it checks on the Mac: pending updates, automatic security updates, disk encryption (FileVault), firewall, built-in protections (SIP, Gatekeeper), screen lock, guest user, sharing, apps open to your Wi-Fi network, API keys or passwords sitting in plain files, secrets in Terminal history, SSH key permissions.
