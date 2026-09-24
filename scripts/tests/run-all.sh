#!/usr/bin/env bash
# Smoke tests for the repository: run from anywhere, exit non-zero on any failure.
#   bash scripts/tests/run-all.sh
#
# They check what a reader relies on, without the 190 GB microdata:
#   1. every committed data file matches data-raw/SHA256SUMS, and SHA256SUMS
#      lists exactly the committed data files;
#   2. the two analysis scripts are the recorded versions;
#   3. (check-repo.R) the scripts parse, every path they read or write exists
#      in a fresh clone, every data file is documented, every HMD reference
#      code of the Sweden file has a source, and CITATION.cff cites the paper.
# The full analysis needs the microdata and is not run here.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

fail=0
sha256() { if command -v sha256sum >/dev/null; then sha256sum "$@"; else shasum -a 256 "$@"; fi; }

# 1. data checksums, against the committed files only (git knows what is committed;
#    local extras such as the extracted microdata are not part of the repository)
listed=$(awk '{print $2}' data-raw/SHA256SUMS | sort)
committed=$(git ls-files data-raw | sed 's|^data-raw/||' | grep -v -x -e README.md -e SHA256SUMS | sort)
if [ "$listed" != "$committed" ]; then
  echo "FAIL checksums: SHA256SUMS does not list exactly the committed data files"
  diff <(echo "$listed") <(echo "$committed") | sed 's/^/  /' || true
  fail=1
elif ! (cd data-raw && sha256 -c SHA256SUMS >/dev/null 2>&1); then
  echo "FAIL checksums: a data file differs from SHA256SUMS"
  (cd data-raw && sha256 -c SHA256SUMS 2>/dev/null | grep -v ': OK$' | sed 's/^/  /') || true
  fail=1
else
  echo "ok   checksums: $(echo "$committed" | wc -l | tr -d ' ') data files match SHA256SUMS"
fi

# 2. the analysis scripts are the recorded versions: an edit must be a deliberate release
while read -r want file; do
  got=$(sha256 "$file" | awk '{print $1}')
  if [ "$got" != "$want" ]; then echo "FAIL scripts: $file changed (sha256 $got)"; fail=1; fi
done <<'EOF'
73f7283c0e229618eec0e15e709f3d9b309473f3dbd28de970de49bdbf656b61 r-scripts/1-covid-19-datasus-vaccine.R
ba7f2192f3762d0af4a2597e01a946e652d98a4a74569298665a514cb283f1e6 r-scripts/2-covid-19-datasus-vaccine-plots.R
EOF
[ $fail -eq 0 ] && echo "ok   scripts: both analysis scripts are the recorded versions"

# 3. the checks that need R
Rscript scripts/tests/check-repo.R || fail=1

if [ $fail -ne 0 ]; then echo "smoke tests FAILED"; exit 1; fi
echo "all smoke tests passed"
