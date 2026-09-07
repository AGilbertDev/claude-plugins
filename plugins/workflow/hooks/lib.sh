#!/usr/bin/env bash
# Shared helpers for the workflow hooks. Source it at the top of a hook, then
# read fields with hook_field. It captures the hook JSON from stdin once.
hook_input="$(cat)"

# Print tool_input.<field> from the captured JSON. Empty when absent or unparsable.
hook_field() {
  local field=$1
  if command -v node >/dev/null 2>&1; then
    node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{const t=JSON.parse(s).tool_input||{};process.stdout.write(String(t[process.argv[1]]??""))}catch{}})' "$field" <<<"$hook_input"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("tool_input",{}).get(sys.argv[1]) or "", end="")
except Exception: pass' "$field" <<<"$hook_input"
  fi
}

# True when the command runs the given git subcommand, with any global options
# such as -C <dir> or --no-pager between git and the subcommand.
is_git() {
  local sub=$1 cmd=$2
  printf '%s' "$cmd" | grep -Eq "(^|[^[:alnum:]_.-])git([[:space:]]+-[^[:space:]]*([[:space:]]+[^-[:space:]][^[:space:]]*)?)*[[:space:]]+${sub}([[:space:]]|$)"
}

# Print the directory given to git -C, when any, so checks run in the right repo.
git_c_dir() {
  printf '%s' "$1" | sed -nE 's/.*git[[:space:]]+-C[[:space:]]+("([^"]+)"|([^[:space:]]+)).*/\2\3/p' | head -1
}
