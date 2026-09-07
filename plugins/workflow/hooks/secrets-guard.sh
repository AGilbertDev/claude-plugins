#!/usr/bin/env bash
# PreToolUse guard for Bash, Edit, and Write.
#
# Blocks any shell command or file edit that touches a secrets file. The deny
# rules in settings.json stop the Read tool and the obvious cat and grep, but a
# denylist of commands cannot be complete. This guard looks at the file names
# instead, so sed, python, cp, and redirection are covered too.
#
# Allowed on purpose: .env.example, and loading a file into a process with
# --env-file, which never prints its contents. Fails open on anything it cannot
# parse, so it never blocks unrelated work. Exit 2 blocks and shows the message.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

target="$(hook_field command)"
[ -z "$target" ] && target="$(hook_field file_path)"
[ -z "$target" ] && exit 0

# Strip the allowed forms before matching.
scrubbed="$(printf '%s' "$target" \
  | sed -E 's/--env-file(=|[[:space:]]+)[^[:space:]]*//g' \
  | sed -E 's/\.env\.example//g')"

pattern='(^|[[:space:]/'"'"'"=:(\\])\.env(\.[A-Za-z0-9_.-]+)?($|[[:space:]'"'"'";|&)>,\\])|(^|[[:space:]/'"'"'"=])secrets/|\.pem($|[[:space:]"'"'"'\\])|\.key($|[[:space:]"'"'"'\\])|id_rsa|id_ed25519|\.credentials\.json|\.npmrc|\.netrc'

if printf '%s' "$scrubbed" | grep -Eq "$pattern"; then
  {
    echo "Blocked: that touches a secrets file."
    echo "Never read, print, copy, or edit .env or other secrets files. If a value is needed, ask the user to set it."
    echo "Loading one into a process with --env-file is fine and is not what was blocked."
  } >&2
  exit 2
fi

exit 0
