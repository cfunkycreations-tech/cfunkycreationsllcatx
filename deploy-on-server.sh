#!/bin/bash
# Assemble clean Lyricist zip from GitHub chunks + deploy assets
# Run from: ~/domains/cfunkycreationsllc.com/public_html/
set -e
cd ~/domains/cfunkycreationsllc.com/public_html/ || exit 1
SHA="8a384d920d81bc465ca912f95fa2f52d3a430539"
echo "Using commit SHA: $SHA"

# --- 1) Pull latest hero + marbles + footer via raw github ---
# (or: git pull if this folder is a clone)
mkdir -p marbles footer appchunks_tmp

# Download assemble helper files from raw github
BASE="https://raw.githubusercontent.com/cfunkycreations-tech/cfunkycreationsllcatx/$SHA"

curl -fsSL "$BASE/hero-live.html" -o hero-test.html
curl -fsSL "$BASE/footer/coffee-right.gif" -o footer/coffee-right.gif
curl -fsSL "$BASE/footer/bmc-suno-badge.svg" -o footer/bmc-suno-badge.svg

# Marbles (13 static + 13 gif)
for n in songwriter ghostrider rhymehelper thesaurus dictionary scratchpad songforge recordingbooth midistudio albumarchitect masteringstudio aitoolshub settings; do
  curl -fsSL "$BASE/marbles/${n}_static.png" -o "marbles/${n}_static.png"
  curl -fsSL "$BASE/marbles/${n}.gif" -o "marbles/${n}.gif"
  echo "marble $n ok"
done

# --- 2) Zip chunks ---
mkdir -p appchunks_tmp
for p in aa ab ac ad ae af ag ah; do
  echo "chunk $p..."
  curl -fL "https://raw.githubusercontent.com/cfunkycreations-tech/cfunkycreationsllcatx/$SHA/appchunks/zpart_$p" -o "appchunks_tmp/zpart_$p"
done

# Assemble
cat appchunks_tmp/zpart_a{a,b,c,d,e,f,g,h} > Lyricist.zip
cp -f Lyricist.zip Lyricist-4.1.3.012.zip
ls -l Lyricist.zip Lyricist-4.1.3.012.zip
# Expect ~729677003 bytes

# Verify zip
python3 - <<'PY'
import zipfile, os
for name in ("Lyricist.zip","Lyricist-4.1.3.012.zip"):
    z=zipfile.ZipFile(name)
    e=z.namelist()[0]
    info=z.getinfo(e)
    print(name, "entries", len(z.namelist()), "inner", e, "size", info.file_size)
    z.close()
    print(" outer_bytes", os.path.getsize(name))
PY

rm -rf appchunks_tmp
echo "DONE. Test: https://www.cfunkycreationsllc.com/hero-test.html?v=21"
echo "Download test: https://www.cfunkycreationsllc.com/Lyricist.zip"
