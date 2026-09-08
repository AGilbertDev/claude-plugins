# claude-plugins

This repository is the marketplace. The always-on core it ships lives in `plugins/workflow/core.md` and reaches a session through the workflow plugin's session-start hook, not through an import.

Before pushing, run `claude plugin validate . --strict` and `bash plugins/workflow/hooks/tests/run.sh`. Both run in CI as well.
