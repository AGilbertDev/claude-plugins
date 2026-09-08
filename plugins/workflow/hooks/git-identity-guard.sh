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
expected_owner="${AGD_GIT_OWNER:-$expected_name}"
cmd="$(hook_field command)"
[ -z "$cmd" ] && exit 0

if ! is_git commit "$cmd" && ! is_git push "$cmd"; then
  exit 0
fi

dir="$(git_c_dir "$cmd")"
[ -n "$dir" ] && cd "$dir" 2>/dev/null

# Guard only what this hook can prove is mine, which is a repository whose
# origin remote sits under my own account. Anything else passes through, including
# a repository with no remote, because blocking a legitimate commit in somebody
# else's repository costs far more than missing one of mine before its first push.
remote="$(git config --get remote.origin.url 2>/dev/null || true)"
[ -z "$remote" ] && exit 0
owner="$(printf '%s' "$remote" \
  | sed -E 's#^[a-z+]+://([^@]*@)?[^/]+/##; s#^[^@]+@[^:]+:##; s#/[^/]*$##; s#^.*/##')"
[ "$owner" != "$expected_owner" ] && exit 0

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
