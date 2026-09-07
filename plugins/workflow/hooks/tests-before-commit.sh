#!/usr/bin/env bash
# PreToolUse(Bash) gate. A git commit does not happen while the test suite fails.
#
# When the command is a git commit, this runs the project's test script first
# and blocks the commit on a non-zero exit. The commit skill and the pipeline
# rely on this instead of asking the model to remember. There is no bypass flag
# on purpose. Commits that stage only Markdown skip the run, since no code
# changed. Fails open when there is nothing to run, such as a repo with no test
# script, so documentation repos are not slowed down.
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

cmd="$(hook_field command)"
is_git commit "$cmd" || exit 0
case "$cmd" in *"--help"*) exit 0 ;; esac

# Run inside the repo the commit targets. Honour git -C <dir> when present.
dir="$(git_c_dir "$cmd")"
[ -n "$dir" ] && cd "$dir" 2>/dev/null

# Nothing but Markdown staged means no code changed.
staged="$(git diff --cached --name-only 2>/dev/null || true)"
if [ -n "$staged" ] && ! printf '%s\n' "$staged" | grep -Evq '\.(md|mdx|txt)$'; then
  exit 0
fi

run=""
if [ -f package.json ] && node -e 'const s=require("./package.json").scripts||{}; process.exit(s.test?0:1)' 2>/dev/null; then
  if [ -f bun.lock ] || [ -f bun.lockb ]; then run="bun run test"
  elif [ -f pnpm-lock.yaml ]; then run="pnpm test"
  else run="npm test --silent"; fi
elif ls ./*.sln ./*.csproj >/dev/null 2>&1; then
  run="dotnet test"
fi
[ -z "$run" ] && exit 0

log="$(mktemp)"
if $run >"$log" 2>&1; then
  rm -f "$log"
  exit 0
fi

{
  echo "Blocked: the test suite fails, so this commit does not happen. Fix the tests first."
  echo "Command: $run"
  echo "Last lines of output:"
  tail -n 25 "$log"
} >&2
rm -f "$log"
exit 2
