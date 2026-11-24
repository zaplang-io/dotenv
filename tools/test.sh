#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
zap=${ZAP:-zap}
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
trap 'exit 1' HUP INT TERM
export ZAP_CACHE="$scratch/cache"
unset ZAP_ZENV

# Scaffold stage: there is no public API to exercise from a consumer yet, so this
# checks formatting and runs the local test suite directly. The python-dotenv-style
# consumer-install dry-run (install this checkout as a dependency and import it),
# per the package guidelines, is wired up when the first-slice public API lands
# via the epic's sub-issues.
"$zap" fmt --check "$root/src" "$root/tests"
"$zap" test "$root/tests/"
