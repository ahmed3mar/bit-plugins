# db

Database connections for bit: MySQL/MariaDB, Postgres and SQLite.

- **Databases** (right sidebar): saved connections with their status; pick one to see its tables, open a table, or start a query. `+` adds one.
- **Query** panel: a SQL editor, results, history, copy as CSV/JSON/text, Explain, and Run write on writable connections (after a confirm).
- **Table** panel: columns, indexes, the first 100 rows, and the DDL.
- **Tools / CLI**: `db.connections`, `db.add`, `db.edit`, `db.remove`, `db.test`, `db.disconnect`, `db.databases`, `db.tables`, `db.describe`, `db.query`, `db.explain`, `db.exec` — also `bit db <command>` while the app is open.

## Safety

- Connections are **read-only** unless saved `writable`. Reads run in a read-only transaction (mysql/postgres; postgres also gets `default_transaction_read_only`), SQLite files open `mode=ro` + `query_only`. `db.query` also refuses anything but one read statement.
- `db.exec`, `db.add`, `db.edit` and `db.remove` are `execute` tools, so they ask permission; the read tools don't.
- Passwords are kept in the macOS Keychain (service `bit-db`), entered on stdin, never in argv, `connections.json` (`~/.bit/db`, mode 0600) or a tool's input. `passwordEnv` names an environment variable instead.
- `mask` columns come back as `***`. Rows are capped (200 by default, 5000 max), cells at 4 KB, queries at 25 s.

## Build

```sh
just build   # bin/bit-db
just test
just link    # into ~/.bit/plugins/db, then restart the bit server
bit-db password <id>   # set a connection's password (hidden prompt, or stdin)
```
