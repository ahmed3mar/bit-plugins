# Bit plugins

The plugins of [Bit](https://github.com/ahmed3mar/bit), as a marketplace. This repository hosts each plugin's manifest, skills and programs for every platform; their source is maintained separately.

## Install

```bash
bit plugin marketplace add ahmed3mar/bit-plugins
bit plugin install db@bit
```

Or in the desktop app: Settings → Plugins → Browse. `bit plugin install` shows what a plugin runs on your machine before it installs, downloads its program for your platform from this repository's releases, and checks it against the release's `checksums.txt`.

`bit plugin update` installs newer versions; `bit plugin uninstall <name>` removes one.

## Plugins

| Plugin | What it does | Platforms |
| --- | --- | --- |
| `assistant` | A virtual you: answers on Telegram and Slack, keeps todos, opens other agents for work | macOS, Linux |
| `db` | MySQL, Postgres and SQLite: browse schemas and run queries, read-only by default | macOS, Linux |
| `github` | PRs waiting on your review, your PRs, the branch's PR and its checks | macOS, Linux |
| `routines` | Prompts that run on a schedule: briefings, checks, reminders | macOS, Linux |
| `security` | Network capture and security tools | macOS, Linux |
| `simulator` | iOS Simulator and Android emulator: see, tap, type, install, launch, logs | macOS |
| `worker` | This machine as a worker of a cloud org | macOS, Linux |

The catalog, [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json), lists the plugins released so far.

## Layout

```
.claude-plugin/marketplace.json     the catalog (Claude Code's format)
plugins/<name>/
  .claude-plugin/plugin.json        name, version, description
  .bit/plugin.json                  what Bit runs, and where its programs are
  skills/                           its skills, if any
```

Programs are release assets: `<name>-v<version>` holds `<program>_<os>_<arch>.tar.gz` for each platform, and `checksums.txt`.

## Releasing

Run the **Release plugins** workflow (Actions → Release plugins → Run workflow). It checks out the source at `ref`, builds every plugin whose version has no release yet (or those named), publishes the releases, then commits their public files and the catalog here. To release a plugin, raise its `version` in the source first.

The workflow needs, in the `production` environment:

- `SOURCE_REPO`: the private source repository, `owner/name`
- `SOURCE_TOKEN`: a token that can read it (Contents: read)
