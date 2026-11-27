---
description: Hand this thread to the cloud; a worker goes on with its work and conversation
argument-hint: <what the cloud's agent is to do from here>
allowed-tools: Bash
disable-model-invocation: true
---
The person hands the rest of this thread's work to the cloud. Run this one command in the shell, with their instruction exactly as written below, quoted so the shell takes it as one argument and runs nothing of it:

```bash
bit cloud delegate "$(cat <<'BIT_DELEGATE'
$ARGUMENTS
BIT_DELEGATE
)"
```

If the instruction is empty, ask them what the cloud's agent should do, and stop.

The command prints a JSON line. When it works, tell them in two lines: the task's key and branch, and that `/pull <key>` brings the work back once it is done. Then stop: do no more work on this task here, since the cloud has it now. If it fails, show its error as it is and say what would fix it (sign in with `bit login`, add the repo to a cloud project, `--project` when the repo is in several); do not try other ways to delegate.
