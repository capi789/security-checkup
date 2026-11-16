# Security Checklist (15 minutes, do it once)

Most people get hacked one of three ways: a **reused password**, a **stolen phone number (SIM swap)**, or **someone tricking them into reading out a code**. This list closes all three. Do it in order: the top items matter most.

## 1. Email first (it's the master key)
Whoever gets your email can reset every other password.
- [ ] Turn on 2-step verification: **Gmail:** myaccount.google.com > Security. **iCloud:** Settings > your name > Sign-In & Security.
- [ ] Use an **authenticator app or a passkey**, not text messages, when it's offered.
- [ ] Gmail: run **myaccount.google.com/security-checkup**. Remove devices you don't know and apps you don't use.
- [ ] Gmail > Settings > **Forwarding**: make sure nothing is forwarding your mail to an address you don't know. Hackers hide this.
- [ ] Save your **backup codes** somewhere safe (password manager or printed in a drawer).

## 2. A password manager (stop reusing passwords)
- [ ] iPhone/Mac: the free **Passwords** app. Android/Chrome: **Google Password Manager**.
- [ ] Open **Security Recommendations** (Apple) or **Password Checkup** (passwords.google.com) and change every password marked **leaked** or **reused**. Start with email, bank and Apple/Google.
- [ ] Check your email at **haveibeenpwned.com** to see which sites leaked it.

## 3. Lock your phone number (stops SIM swaps)
A thief calls your carrier, moves your number to their phone, and gets all your text codes.
- [ ] **T-Mobile:** app > Account > Profile settings > **SIM Protection** + **Port Out Protection**.
- [ ] **Verizon:** app > Account > Security > **Number Lock** + **SIM Protection**.
- [ ] **AT&T:** app > **Wireless Account Lock**.
- [ ] Others (Visible, Mint, Cricket...): call or chat and ask for a **port-out PIN / number lock**.

## 4. Your phone
- [ ] **iPhone:** Settings > Face ID & Passcode > **Stolen Device Protection: On**. Use a 6-digit passcode, not 4.
- [ ] **Android:** Settings > Google > **Theft protection**: turn on Theft Detection Lock and Offline Device Lock.
- [ ] Updates on automatically (iPhone: General > Software Update; Android: System > Software update).
- [ ] Delete apps you don't use. Remove any **profile** you don't recognize (iPhone: General > VPN & Device Management).

## 5. Money
- [ ] Bank and card apps: turn on an **alert for every transaction** (any amount).
- [ ] **Freeze your credit** (free, 10 minutes, nobody can open a loan in your name): equifax.com, experian.com, transunion.com. You can unfreeze any time you need credit.
- [ ] Turn on 2-step verification on banking, PayPal, Venmo, Cash App, Zelle and crypto apps.

## 6. Home Wi-Fi
- [ ] Change the router's admin password from the default (printed on the sticker).
- [ ] Update the router (its app or admin page) and use WPA2 or WPA3.

## 7. The rules that stop scams
- **Never read a code to anyone.** No bank, Apple, Google or carrier will ever call and ask for it.
- Got a scary call or text from "your bank"? **Hang up and call the number on the back of your card.**
- Don't click links in texts about packages, tolls or locked accounts. Open the app yourself.
- Urgency is the trick. If someone is rushing you, it's a scam.

## 8. Mac only
Run the automatic checkup in Terminal:
```
zsh check-my-mac.sh
```
It only looks; it changes nothing and sends nothing anywhere.
