---
name: db
description: Query and inspect the user's databases (MySQL, Postgres, SQLite) through the db plugin's tools — list connections, browse tables, describe schemas, run read-only SQL, explain slow queries. Use when asked to look at data, check a table, debug a query, or anything "in the database".
---

# Databases

The `db.*` tools reach the connections the user saved (Databases sidebar, or `db.add`). Every connection is read-only unless the user made it writable.

1. **Find the connection.** `db.connections` lists them. Pass `conn` (id or name) to the other tools; with only one connection you can leave it out.
2. **Look before you write SQL.** `db.tables`, then `db.describe` for each table you'll touch. Don't guess column names.
3. **Query small.** `db.query` runs one read statement in a read-only session. Name the columns (no `SELECT *` on wide tables), add `LIMIT`, and filter on indexed columns. 200 rows come back by default (`limit` up to 5000); the footer says when more were cut. Use `format: json` when you'll process the rows.
4. **Slow query?** `db.explain` first, then suggest an index or a rewrite. Don't run heavy aggregates on a big production table to find out.
5. **Writes.** `db.exec` only when the user asked for the change, on a writable connection; it asks them first. Say what it will change, and prefer a `SELECT` of the rows it would touch beforehand.
6. **Secrets.** Never ask for or pass a password to a tool. If a connection needs one, tell the user to set it in the Databases sidebar (Edit) or run `bit-db password <id>`. Masked columns show `***`; don't try to get around them.
