# Lyricist site — what was broken, what’s fixed, what you must deploy

**Date:** 2026-07-20  
**Owner of assets:** Grok (this folder)  
**Deploy still:** you or Claude via InterServer DirectAdmin terminal  

---

## 1. THE ZIP — “corrupted download” (THIS WAS REAL)

### Root cause (not the rename)
| File on live server | Size | Status |
|---|---|---|
| `Lyricist-4.1.3.012.zip` | **~369 MB** (386,531,328 bytes) | **TRUNCATED / CORRUPT** — half the file |
| `Lyricist.zip` | **~696 MB** (729,681,914 bytes) | Full-ish, but not our latest clean pack |
| Download button in `hero-live.html` | pointed at **`Lyricist-4.1.3.012.zip`** | **That’s why your download was fucked** |

Renaming to `Lyricist.z` is **also** bad (Windows won’t treat it as a zip). Keep the extension **`.zip`**. That was not the main corruption; the half-upload was.

### What a good package is
- Installer EXE: **`Lyricist 4.1.3.012.exe`** ≈ **695.83 MB**
- Clean zip (verified openable): **`Lyricist-4.1.3.012-CLEAN.zip`** ≈ **695.87 MB**
- Inside the zip: one file → **`Lyricist-Setup-4.1.3.012.exe`** (729,632,094 bytes)
- SHA-256 of the EXE:  
  `CF77E1CFE1F1AA875E820F79B3C120815B7D7DF2371EB1D787023D176AED0089`

### Local copies ready to upload (both identical good zips)
```
C:\Users\crafu\cfunkycreationsllcatx\Lyricist.zip                 (~696 MB)
C:\Users\crafu\cfunkycreationsllcatx\Lyricist-4.1.3.012.zip       (~696 MB)
C:\Users\crafu\OneDrive\Desktop\New Lyricist Release\Lyricist-4.1.3.012-CLEAN.zip
C:\Users\crafu\OneDrive\Desktop\New Lyricist Release\Lyricist-4.1.3.012.sha256
```

### Why the installer said “2 GB”
Electron-builder / NSIS often shows a **wild estimated disk space** (unpacked + temp + padding).  
**The real download is ~696 MB.** The app install footprint is roughly that order, not 2 GB of download. Ignore the scary estimate if the file size on disk is ~696 MB.

### HTML fix already done locally
Download button now points at **`Lyricist.zip`** (the full file that already mostly works live), with note:
- ~696 MB zip  
- Unzip → run `Lyricist-Setup-4.1.3.012.exe`

**You still must re-upload both zips** so `Lyricist-4.1.3.012.zip` is no longer the truncated 369 MB corpse, and so `Lyricist.zip` matches our clean SHA.

### Safe deploy for big zip (DirectAdmin terminal — proven chunk method)
From a machine that has the clean zip, or after pushing chunks to GitHub:

```bash
# On server public_html — AFTER full file is assembled:
ls -l Lyricist.zip Lyricist-4.1.3.012.zip
# Both must be ~729677003 bytes (or within a few KB of that)
# Verify zip opens:
python3 - <<'PY'
import zipfile
z=zipfile.ZipFile('Lyricist.zip')
print(z.namelist(), z.getinfo(z.namelist()[0]).file_size)
z.close()
PY
```

If File Manager chokes on 700 MB, use the **90 MB chunk relay** from `HANDOFF-LYRICIST-SITE.md` (`split` / `cat` / `sha256sum`).

---

## 2. THE MARBLES — backgrounds + some don’t spin

### What was wrong
- Live site still had **old mixed assets** (some 280px glint GIFs, some 512px with **opaque black** backgrounds).
- Earlier spin GIFs lost alpha on several tools (songwriter / songforge / recordingbooth / etc. → **0% transparent**).
- So: square black boxes on light cards, and hover spin inconsistent.

### What I fixed (local `marbles/`)
All **13** marbles rebuilt:
- Flood-keyed dark background → real alpha
- 512×512 static PNG + **18-frame spin GIF**, every one transparent (~21–38% clear pixels)
- Names match `hero-live.html`:  
  `songwriter`, `ghostrider`, `rhymehelper`, `thesaurus`, `dictionary`, `scratchpad`, `songforge`, `recordingbooth`, `midistudio`, `albumarchitect`, `masteringstudio`, `aitoolshub`, `settings`

Folder: `C:\Users\crafu\cfunkycreationsllcatx\marbles\`  
(Source originals still in `marbles_grok/`)

**Live server still has the OLD marbles until you deploy this folder.**

---

## 3. FOOTER — “Buy me SUNO” + coffee GIF

### What’s supposed to be there
| Side | Asset | Path |
|---|---|---|
| LEFT of medallion | “Buy me some SUNO credits” badge | **`footer/bmc-suno-badge.svg`** (now **self-hosted** — was hotlinked to buymeacoffee CDN, which often breaks / looks blank) |
| CENTER | Spinning medallion | embedded in HTML |
| RIGHT | Animated coffee cup | **`footer/coffee-right.gif`** (already good locally + already live; transparent) |

### HTML fix already done locally
BMC img src changed from external API URL → `footer/bmc-suno-badge.svg`.

Coffee GIF is fine (48 frames, ~77% transparent). If it looked “fucked” after a terminal download, you likely got a truncated/wrong file — re-upload from local `footer/coffee-right.gif` (511,366 bytes).

---

## 4. WHAT YOU NEED TO DO (checklist)

1. **Upload zips** (both names, full ~696 MB each) into `public_html/`:
   - `Lyricist.zip`
   - `Lyricist-4.1.3.012.zip`  
   Confirm sizes ≈ **729,677,003** bytes (not 386M).

2. **Upload marbles** entire folder `marbles/*.png` + `marbles/*.gif` (overwrite live).

3. **Upload footer**:
   - `footer/bmc-suno-badge.svg`
   - `footer/coffee-right.gif` (refresh if broken)

4. **Deploy updated HTML**:
   - Push `hero-live.html` → curl to `hero-test.html` (SHA method from handoff)
   - Hard refresh: `https://www.cfunkycreationsllc.com/hero-test.html?v=20`
   - When happy: swap to `index.html` (only with your “go”)

5. **Do NOT** rename zip to `.z`. Keep `.zip`.

6. **Verify download**:
   - Downloaded zip should be ~696 MB
   - Opens → one EXE ~696 MB
   - Installer “2 GB” estimate is noise; file on disk is what matters

---

## 5. What I cannot do from here
- I cannot log into DirectAdmin / push to InterServer for you.
- Claude was handling deploy; with Claude asleep, **you** need to upload or wake Claude with this file + `HANDOFF-LYRICIST-SITE.md`.

---

## 6. Quick “is the zip good?” test on your PC
```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$z = [IO.Compression.ZipFile]::OpenRead("C:\Users\crafu\cfunkycreationsllcatx\Lyricist.zip")
$z.Entries | Select-Object FullName, Length
$z.Dispose()
# Expect: Lyricist-Setup-4.1.3.012.exe  Length=729632094
```
