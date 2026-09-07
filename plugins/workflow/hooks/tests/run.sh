#!/usr/bin/env bash
# Tests for the workflow hooks. Run from anywhere: bash plugins/workflow/hooks/tests/run.sh
# Each case feeds a hook the JSON Claude Code would send and checks the exit code.
# Exit 2 blocks the tool call. Exit 0 lets it through.
set -uo pipefail
HOOKS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

check() { # expected label
  local exp=$1 label=$2 code=$3
  if [ "$code" = "$exp" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL  $label  got $code, expected $exp"; fi
}
feed() { # hook tool_name key json-value [cwd]
  local hook=$1 name=$2 key=$3 val=$4 dir=${5:-$TMP}
  (cd "$dir" && printf '{"tool_name":"%s","tool_input":{"%s":%s}}' "$name" "$key" "$val" | bash "$HOOKS/$hook" >/dev/null 2>&1)
  echo $?
}

# ---- fixtures: three tiny repos ----
if command -v bun >/dev/null 2>&1; then lock=bun.lock; else lock=package-lock.json; fi
mkrepo() { # name test-script git-name
  local d="$TMP/$1"; mkdir -p "$d"; (cd "$d" && git init -q && git config user.name "$3" && git config user.email t@t \
    && printf '{"name":"%s","scripts":{"test":"%s"}}' "$1" "$2" > package.json && touch "$lock" && echo 'export const a = 1' > a.ts \
    && git add package.json "$lock" a.ts)
}
mkrepo failing 'exit 1' AGilbertDev
mkrepo passing 'echo ok' AGilbertDev
mkrepo work    'echo ok' WorkAccount
mkdir -p "$TMP/docs-only" && (cd "$TMP/docs-only" && git init -q && echo x > README.md && git add README.md)

# ---- secrets guard ----
g=secrets-guard.sh
check 2 "cat .env"                        "$(feed $g Bash command '"cat .env"')"
check 2 "sed on .env.local"               "$(feed $g Bash command '"sed -n p .env.local"')"
check 2 "copy .env"                       "$(feed $g Bash command '"cp .env /tmp/x"')"
check 2 "append to .env"                  "$(feed $g Bash command '"echo FOO=bar >> .env"')"
check 2 "quoted .env path"                "$(feed $g Bash command '"cat \"./.env\""')"
check 2 "python opening .env"             "$(feed $g Bash command '"python3 -c \"print(open(\\\".env\\\").read())\""')"
check 2 "secrets folder"                  "$(feed $g Bash command '"cat secrets/token.txt"')"
check 2 "claude credentials"              "$(feed $g Bash command '"cat ~/.claude/.credentials.json"')"
check 2 "write .env"                      "$(feed $g Write file_path '"/p/.env"')"
check 2 "edit a private key"              "$(feed $g Edit file_path '"/p/certs/server.key"')"
check 0 ".env.example"                    "$(feed $g Bash command '"cat .env.example"')"
check 0 "--env-file= load"                "$(feed $g Bash command '"bun run --env-file=.env scripts/seed.ts"')"
check 0 "--env-file load"                 "$(feed $g Bash command '"bun run --env-file .env.production scripts/seed.ts"')"
check 0 "process.env in code"             "$(feed $g Bash command '"node -e \"console.log(process.env.X)\""')"
check 0 "env.ts source file"              "$(feed $g Bash command '"ls src/env.ts"')"
check 0 ".envrc"                          "$(feed $g Bash command '"cat .envrc"')"
check 0 "word in a message"               "$(feed $g Bash command '"git commit -m \"fix env handling\""')"
check 0 "secretsManager identifier"       "$(feed $g Bash command '"grep -rn secretsManager src/"')"
check 0 "write .env.example"              "$(feed $g Write file_path '"/p/.env.example"')"
check 0 "edit env.ts"                     "$(feed $g Edit file_path '"/p/server/utils/env.ts"')"

# ---- tests before commit ----
g=tests-before-commit.sh
check 2 "failing suite blocks commit"     "$(feed $g Bash command '"git commit -m x"' "$TMP/failing")"
check 2 "git -C into failing repo"        "$(feed $g Bash command "\"git -C $TMP/failing commit -m x\"")"
check 2 "global option before commit"     "$(feed $g Bash command '"git --no-pager commit -m x"' "$TMP/failing")"
check 0 "passing suite"                   "$(feed $g Bash command '"git commit -m x"' "$TMP/passing")"
check 0 "not a commit"                    "$(feed $g Bash command '"git status"' "$TMP/failing")"
check 0 "commit as a word"                "$(feed $g Bash command '"echo committing soon"' "$TMP/failing")"
check 0 "no test script"                  "$(feed $g Bash command '"git commit -m x"' "$TMP/docs-only")"
(cd "$TMP/failing" && git reset -q && echo notes > README.md && git add README.md)
check 0 "only markdown staged"            "$(feed $g Bash command '"git commit -m x"' "$TMP/failing")"

# ---- identity guard ----
g=git-identity-guard.sh
check 2 "work identity commit"            "$(feed $g Bash command '"git commit -m x"' "$TMP/work")"
check 2 "work identity push"              "$(feed $g Bash command '"git push origin main"' "$TMP/work")"
check 2 "work identity via -C"            "$(feed $g Bash command "\"git -C $TMP/work commit -m x\"")"
check 0 "personal identity"               "$(feed $g Bash command '"git commit -m x"' "$TMP/passing")"
check 0 "not git"                         "$(feed $g Bash command '"ls"' "$TMP/work")"

echo "hooks: $pass passed, $fail failed"
[ "$fail" = 0 ]
