# LYRICIST SITE — SESSION HANDOFF (paste into a fresh Claude chat to continue)

You're continuing a build already ~90% done. Read this whole thing first — do NOT re-derive it.

## WHO
Owner is **Chris Funk** (Christopher Funk). NOT Craig (that's his brother). Call him Funk/Chris.
Working style: move fast, don't waste tokens, show visual results, don't re-ask what's answered here, get a nod before irreversible things (homepage swap, deploys). He's launching to ~20 Facebook groups TODAY and wants EVERYTHING done, all 13 marbles included.

## THE SITE + DEPLOY PIPELINE (this is the crown jewel — it works)
- Live site: **https://www.cfunkycreationsllc.com** (keeps the "y"). Lyricist 4.1.3 landing page.
- Hosted on **INTERSERVER**, control panel **DirectAdmin** at `https://vda6600.is.cc:2222/evo/` (SSO via my.interserver.net → Web Hosting → Control Panel). Web root: `~/domains/cfunkycreationsllc.com/public_html/`.
- **Cloudflare** sits in front (Server: cloudflare; it CACHES — bust with `?v=N` on pages, or use a fresh filename for big files).
- NOT GitHub Pages, NOT Vercel. The GitHub repo is only a **relay** for the deploy pipeline.
- Repo (relay): `github.com/cfunkycreations-tech/cfunkycreationsllcatx`, local clone at **`C:\Users\crafu\cfunkycreationsllcatx`**. Git push works (credential manager). Chris logged into GitHub in Brave.

**PROVEN DEPLOY (no Chris interaction):**
1. Edit locally in `C:\Users\crafu\cfunkycreationsllcatx` (main working file: **`hero-live.html`** = the new full site).
2. `git -c user.name="Chris Funk" -c user.email="funkchristo@gmail.com" commit` + `git push origin main`. Get the SHA (`git rev-parse HEAD`).
3. Open DirectAdmin **Terminal** (`/evo/terminal`) in Chris's Brave via the claude-in-chrome browser tools.
4. `curl -sL https://raw.githubusercontent.com/cfunkycreations-tech/cfunkycreationsllcatx/<SHA>/hero-live.html -o ~/domains/cfunkycreationsllc.com/public_html/hero-test.html`
   - **Use the COMMIT SHA, not `main`** — raw.github CDN caches ~5 min.
   - **The terminal EATS the first typed command after connecting** — click, type, Enter; if the prompt returns empty, retype the SAME command.
5. Verify live at `https://www.cfunkycreationsllc.com/hero-test.html?v=N`.
- Files >100 MB: split into 90 MB chunks (`split -b 90m file zpart_`), commit to repo `appchunks/`, `curl` each on server, `cat zpart_a? > file`, verify with `sha256sum`. (Used for the app; worked.)
- File-manager uploads DON'T work for me (file_upload only accepts user-shared files).

## STAGING vs LIVE
- **`hero-test.html`** on the server = the NEW site (staging). All work is verified there.
- **`index.html`** = the CURRENT live homepage, still the OLD two-column version — UNTOUCHED on purpose.
- **HOMEPAGE SWAP (final step, needs Chris's "go"):** on server, `cd public_html && cp index.html index-OLD-backup.html && cp hero-test.html index.html`. Reversible in seconds.

## ✅ DONE (live on hero-test.html)
- **Living hero**: Funk brothers photo (`bros.jpg`), corner medallion spins flat (record-style, clasp removed), title "LYRICIST 4.1.3" in **Audiowide**, gradient magenta→orange→**blue** (Chris kept the blue), sits from brother's head to right edge. Circuit sky glows + glitches/shorts. Circuit glow masked OFF both faces/hats.
- **Maker's story**: Chris's exact words (verbatim), then the AI-written "about" section with Chris's orange note ("everything below was written by the AI, unprompted…"). De-echoed: Chris's story no longer says "perfectionist/taskmaster/two-three days" — only the AI section does.
- **6 marbles mounted** on feature cards (static PNG, animate on hover — float+glow+glint): Songwriter, Ghost Rider, Thesaurus, Dictionary, Song Forge, Recording Booth. In `repo/marbles/`. These are MY glint-style builds (cut from Grok stills).
- **App**: v4.1.3.012 (695 MB) deployed via chunk-relay, SHA-256 verified `7001f9…c4c6b`. Download button → `Lyricist-4.1.3.012.zip` (cache-busted name). ⚠️ NOTE: Chris says **Grok is fixing the app and will bring a NEW zip** — re-deploy that when it arrives (chunk method) and verify live Content-Length matches the file.

## ⛔ REMAINING TASKS (Chris wants all done today)
1. **The 7 missing marbles** — Rhyme Helper, Scratchpad, MIDI Studio, Album Architect, Mastering Studio, AI Tools Hub, Settings. Chris made all 13 as **animated transparent (alpha) 1080 GIFs in Grok** (project "Photoreal Glass Marble AI Icons", agent `d6da01a1-0ca8-46ff-b7f5-ec782d26ff37`, logged in as him). **BLOCKER:** every automated grab (fetch/canvas/localhost bridge) is CORS/CSP-blocked; programmatic `<a download>` DOES download the full file but Brave's **"Ask where to save each file"** deletes it before completion. **FIX: Chris must set `brave://settings/downloads` → "Ask where to save each file" = OFF.** Then `<a download>` clicks land in Downloads as `.tmp` (complete valid files) → rename. Consider replacing ALL 13 with Grok's richer animated ones for consistency (the 6 current are simpler glint-style). Downscale ~300px + lazy-load so page stays light.
2. **Fonts** → change ALL site fonts to match the APP's fonts. App font roles (from `C:\Users\crafu\Lyricist-4.0.0\src\index.css` if present, else the app): title=Rubik Glitch, body/buttons/inputs/labels=Metamorphous, lyric/written/accent=Audiowide, labels render orange `#ff7a18`. Confirm exact mapping with Chris; the site currently uses Space Grotesk/Syne/etc.
3. **Donation buttons** → Fiverr, PayPal, Venmo, Cash App, Chime, Buy Me a Coffee: swap to the **exact icons used in the app** — must look identical. Pull the app's button icons/markup (App.jsx footer, ~lines 450-513) and match.
4. **Two graphics for the footer** — one LEFT and one RIGHT of the spinning medallion at the bottom-center. Chris is going to GET/provide these ("gifts"). Also per original plan: footer medallion + two "Buy Me a Coffee" code snippets (Chris provides both).
5. **HOMEPAGE SWAP** — final, on Chris's "go".

## ASSETS / LOCATIONS
- Repo working dir: `C:\Users\crafu\cfunkycreationsllcatx` (hero-live.html, marbles/, marbles/src/ = source sprites: bros.jpg, circuit_glow.png, medallion_spin.png, audiowide-latin.woff2, the 6 cut marble PNGs).
- App builds: `C:\Users\crafu\OneDrive\Desktop\New Lyricist Release\` (current best: `Lyricist 4.1.3.012.exe` 695 MB — will be replaced by Grok's fix).
- App source: `C:\Users\crafu\Lyricist-4.0.0` (for fonts + button icons).
- Pay links: Fiverr fiverr.com/s/m541z1V · PayPal paypal.me/funkchris · Venmo venmo.com/u/Chris-Funk-20 · Cash App cash.app/$cfunkycreations · BuyMeACoffee buymeacoffee.com/cfunkycream · Chime cashtag `$Christopher-Funk-21` (copies to clipboard).

## ACCESS / TOOLS
- Browser: **claude-in-chrome** extension → Chris's **Brave**, deviceId `6acf3bd5-11e0-41ad-b7a5-fdf6bcfdbed1`. Allowed sites: cfunkycreationsllc.com, github.com, brave.com, vercel.com, interserver.com. Terminal tab + Grok tab usually open.
- The in-app Browser pane is policy-blocked from these sites; use claude-in-chrome.
- Screenshots of heavy pages (Grok, big GIFs) sometimes time out — retry or use read_page/javascript_tool.

## STYLE SYSTEM (brand)
Magenta `#ff2d95` · oranges `#ff9e2c #ff7a18 #ff5a1e` · blue `#2d9bff` (KEEP the blue, per Chris) · bg `#07050f` · text `#e8e0ff`. Fonts loaded via Google Fonts link in the file.
