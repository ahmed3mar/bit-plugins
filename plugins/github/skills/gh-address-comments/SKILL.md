---
name: gh-address-comments
description: Address the unresolved review comments on the current branch's PR — fix the code, reply, resolve. Use when asked to address, answer or fix PR review comments.
---
1. Fetch every unresolved thread in ONE GraphQL call (not a REST call per comment):
   `gh api graphql -f query='query($o:String!,$n:String!,$pr:Int!){repository(owner:$o,name:$n){pullRequest(number:$pr){reviewThreads(first:100){nodes{id isResolved path line comments(first:20){nodes{author{login} body}}}}}}}' -F o=OWNER -F n=REPO -F pr=N`
2. For each unresolved thread: fix the code, or, when you disagree, prepare a short reason. Show the owner the plan before pushing.
3. Commit and push once for all fixes (the repo's commit conventions).
4. Reply and resolve, asking first: `addPullRequestReviewThreadReply` then `resolveReviewThread` mutations — batch them in one `gh api graphql` call with aliases.
