#!/usr/bin/env bash
#
# Fill Casks/kobemc.rb with the real version + per-arch sha256 from a kobeMC
# GitHub release. Run after the Release workflow has published the .dmg assets.
#
#   ./update-kobemc.sh 0.1.0
#   git add Casks/kobemc.rb && git commit -m "kobemc 0.1.0" && git push
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

VERSION="${1:?usage: ./update-kobemc.sh <version>   e.g. 0.1.0}"
REPO="Sma1lboy/mc"
CASK="Casks/kobemc.rb"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> Downloading v$VERSION .dmg assets from $REPO"
gh release download "v$VERSION" --repo "$REPO" --pattern "*.dmg" --dir "$TMP" --clobber

arm_dmg="$(find "$TMP" -name '*aarch64*.dmg' | head -1)"
intel_dmg="$(find "$TMP" -name '*x64*.dmg' | head -1)"
[ -n "$arm_dmg" ]   || { echo "error: no aarch64 .dmg found in release" >&2; exit 1; }
[ -n "$intel_dmg" ] || { echo "error: no x64 .dmg found in release" >&2; exit 1; }

arm_sha="$(shasum -a 256 "$arm_dmg"   | awk '{print $1}')"
intel_sha="$(shasum -a 256 "$intel_dmg" | awk '{print $1}')"
echo "   arm  : $(basename "$arm_dmg")  $arm_sha"
echo "   intel: $(basename "$intel_dmg")  $intel_sha"

VERSION="$VERSION" ARM_SHA="$arm_sha" INTEL_SHA="$intel_sha" CASK="$CASK" python3 - <<'PY'
import os, re
ver, arm, intel, path = (os.environ[k] for k in ("VERSION", "ARM_SHA", "INTEL_SHA", "CASK"))
t = open(path, encoding="utf-8").read()
t = re.sub(r'(\bversion ")[^"]*(")', rf'\g<1>{ver}\g<2>', t, count=1)
# First sha256 belongs to on_arm, second to on_intel (order in the file).
shas = iter([arm, intel])
t = re.sub(r'(sha256 ")[0-9a-f]{64}(")', lambda m: f'{m.group(1)}{next(shas)}{m.group(2)}', t)
open(path, "w", encoding="utf-8").write(t)
print(f"   wrote {path}")
PY

echo "==> Done. Review, then:  git add $CASK && git commit -m \"kobemc $VERSION\" && git push"
