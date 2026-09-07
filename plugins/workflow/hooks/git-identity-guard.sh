#!/usr/bin/env bash
# PreToolUse(Bash) guard for personal repos.
#
# Blocks a git commit or git push made under a git user.name other than the
# expected personal one. It only acts on commits and pushes, honours git -C, and
# fails open on anything it is unsure about, so it never blocks unrelated work.
# The check is on user.name, not email, so every personal email passes while a
# work identity does not. Override the expected name with AGD_GIT_NAME.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

expected_name="${AGD_GIT_NAME:-AGilbertDev}"
cmd="$(hook_field command)"
[ -z "$cmd" ] && exit 0

if ! is_git commit "$cmd" && ! is_git push "$cmd"; then
  exit 0
fi

dir="$(git_c_dir "$cmd")"
[ -n "$dir" ] && cd "$dir" 2>/dev/null

name="$(git config user.name 2>/dev/null || true)"

# An unset name is left to git. A matching name is fine.
if [ -n "$name" ] && [ "$name" != "$expected_name" ]; then
  {
    echo "Blocked: git user.name is '$name', not the personal identity '$expected_name'."
    echo "This is a personal repo. Set the local identity, then retry:"
    echo "  git config user.name \"$expected_name\""
    echo "  git config user.email \"<your personal email>\""
  } >&2
  exit 2
fi
exit 0
