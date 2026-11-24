---
name: gh-review
description: Review a GitHub pull request (URL, owner/repo#N, or N in the current repo) and draft the comments as a pending review. Use when asked to review a PR.
---
1. Read the PR once, in one call: `gh pr view <pr> --json title,body,baseRefName,headRefName,files,reviews,comments` then `gh pr diff <pr>`. Don't page through the API file by file.
2. Read the changed files around the diff (locally if the repo is checked out: `gh pr checkout <pr>` only when asked), and the repo's CLAUDE.md / conventions.
3. List real problems only — bugs, security, missing tests, broken conventions — most severe first, each with `file:line` and a one-line fix.
4. Ask before posting. When the owner says so, post everything as ONE review (one API call), not a comment per finding:
   `gh api repos/{owner}/{repo}/pulls/{n}/reviews -f event=COMMENT -f body=... -F 'comments[][path]=...' ...`
   `event=APPROVE` or `REQUEST_CHANGES` only when the owner asks for it.
