---
name: gh-fix-ci
description: Fix the failing CI checks of the current branch's PR. Use when asked to fix CI, a failing check, or a red build.
---
1. Find what failed, once: `gh pr checks --json name,state,link,workflow` (current branch). Only failed ones matter.
2. Fetch only the failed jobs' logs: `gh run view <run-id> --log-failed` — never the full logs, never polled in a loop.
3. Reproduce locally with the repo's own test/lint command, fix the cause (not the test), run it again.
4. Commit following the repo's commit conventions (CLAUDE.md) and push. Then rerun nothing by hand: the push starts CI.
5. To wait on the new run use `gh run watch <id> --interval 30` once, not repeated `gh pr checks` calls.
