---
name: gh-pr
description: Open a pull request for the current branch, following the repo's conventions (branch name, title, template, draft). Use when asked to open, create or raise a PR.
---
1. Read the conventions first: the repo's CLAUDE.md / CONTRIBUTING and `.github/pull_request_template.md`. They win over anything below (title format, emoji, Jira key, attribution lines).
2. Check the branch: pushed (`git push -u origin HEAD` if not), and no PR open yet (`gh pr view --json url` fails).
3. Title and body from the commits since the base (`git log --oneline origin/<base>..HEAD`) and the diff; fill the template, keep its headings.
4. Open it as a draft unless told otherwise: `gh pr create --draft --title ... --body-file ...`. Give the owner the URL.
