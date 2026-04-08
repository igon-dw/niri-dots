#!/bin/bash

# fzf_quick_opener: Entry point placeholder for the future TUI opener.
# The implementation will be split into dedicated files in this directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$SCRIPT_DIR/fzf_quick_opener_core.sh"

main "$@"
