#!/usr/bin/env bash
# PreToolUse(Bash) guard for personal repos.
#
# Blocks a `git commit` or `git push` made under a git user.name other than the
# expected personal one. It reads the tool-call JSON from stdin and only acts
# when the command looks like a commit or push. It fails open on anything it is
# unsure about, so it never blocks unrelated work. Exit 2 is what blocks the
# action and shows the message to Claude.
#
# The check is on user.name, not email, so every personal email (a plain
# address or a GitHub noreply) passes while a work identity does not.
# Fork-friendly: override the expected name with AGD_GIT_NAME.
set -uo pipefail

expected_name="${AGD_GIT_NAME:-AGilbertDev}"

input="$(cat)"

# Only guard commits and pushes. Everything else passes straight through.
case "$input" in
  *"git commit"* | *"git push"*) ;;
  *) exit 0 ;;
esac

name="$(git config user.name 2>/dev/null || true)"

# Unset name is left to git and other guards. A matching name is fine.
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
