---
description: Take a delegated task's work back from the cloud, in a worktree beside this repo
argument-hint: <task key, e.g. B-42>
allowed-tools: Bash
disable-model-invocation: true
---
Run this one command in the shell, the task key quoted:

```bash
bit cloud pull '$ARGUMENTS'
```

It prints a JSON line with the worktree and, when the cloud has the conversation, a session. Tell the person where the worktree is and the command to resume the session there (its `hint`). If it fails, show the error as it is.
