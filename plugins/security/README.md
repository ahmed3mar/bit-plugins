# Security plugin backend

Build with `just build` from this directory. The service starts with the plugin, capturing browser traffic through `127.0.0.1:7783` (HTTP and CONNECT HTTPS). Its CA lives at `~/.bit/security/ca.pem` (private key `ca-key.pem`), and rules at `rules.json`. Rules are saved in `rules.json`, and the workspaces captured in `capture.json`.

**Capture is per workspace.** `proxy.capture {state: on|off, workspace?}` sets it; with no workspace, it sets every one. The manifest's `browserProxy.status` (`proxy.status`) tells the desktop which workspaces are captured, and the others' browser pages go straight out. The proxy also passes a request tagged with a workspace that isn't captured straight on: HTTPS stays unopened, and nothing is kept. Each flow records the browser tab and workspace it came from, taken from the tag at the end of the User-Agent, which the proxy strips.

**The `bit proxy …` commands are generated** by the desktop from this mod's tools (`"cli": ["proxy"]`, `tooldefs.go`): their descriptions, flags and `x-cli` hints. The agent sees the same tools.

## UI

The views are native (`docs/plugin-ui.md`): the mod answers `ui.render` for the Network side and the Request, Repeater and Decoder panels (`network.go`, `ui.go`, `tools.go`, `rules.go`), calling the service for the data. The service serves no pages.

The service's `POST /api/call` on `127.0.0.1:7784` takes `Content-Type: application/json`, `Authorization: Bearer <token>`, body `{"name":"proxy.flows","input":{"limit":50}}`; the JSON response is the **tool's result directly**, not an envelope. The token is written, 0600, to `~/.bit/security/api-token` once the service holds its ports, and changes each run; the mod and CLI read it. Errors return HTTP 400 text. Besides the tools below, the views use `proxy.flow {id}` (the flow with its headers and bodies) and `proxy.rule_set {rule}` (an edited rule).

Authenticated `GET /api/events` is an SSE stream: each change emits `data: {}`. The mod listens at `/api/bridge` and sends `bridge.event` **`proxy.flows`**, which the Network side watches.

## Tools (`proxy.*`)

All tools accept one JSON object. Flows are capped at 3000, response bodies at 4 MB. Responses:

- `proxy.status {}` → `{type:"proxy",capturing,capture:{default,workspaces},port:7783,ca,intercept,intercept_responses,held,rules,flows}`. `proxy.capture {state?,workspace?}`, `proxy.start {workspace?}` and `proxy.stop {workspace?}` set the capture and answer the status.
- `proxy.flows {query?,type?,tab?,workspace?,limit?}` → `{type:"flows",flows:[{id,method,url,status,ms,bytes,type,content_type,tag,error,tab,workspace}]}`, newest first; limit defaults to 50. `type` and `tab` take comma-separated lists. `proxy.flow {id}` is the whole flow, its bodies base64.
- `proxy.show {id:number}` (alias `proxy.get`) → `{type:"flow",flow:summary,request:rawHTTP,response:rawHTTP,text:request+"\n\n"+response}`. `request` is ready to edit for Repeater. `proxy.repeat {id:number,raw?:string}` → the **same detail shape for the new response**; `raw` is the edited HTTP/1.1 request text (request line, headers, blank line, body). A raw absolute URL can also be sent with `id:0`.
- `proxy.intercept {match:string,responses?:boolean}` → status; match is a regex against `METHOD URL`, `match:"off"` disables/forwards all held. `proxy.held {}` → `{type:"held",held:[{id,side:"req"|"res",method,url,raw}]}`. `proxy.forward {id:number,raw?:string,all?:boolean}` or `proxy.drop {id:number,all?:boolean}` → `{}`; `raw` edits the held item.
- `proxy.rules {}` → `{type:"rules",rules:[Rule]}`. `proxy.rule_add {where,match,replace?,name?,off?,status?,content_type?,file?,target?,path?}` (or the same inside `{rule:{…}}`) → `{type:"rule",rule:Rule}`; `proxy.rule_set {id,…}` changes one. `where` is one of `req.header,req.body,res.header,res.body,json,mock,file,url`. `proxy.rule_toggle {id:number,state:"on"|"off"}` and `proxy.rule_remove {id:number}` → `{}`; `id:0` removes all.
- `proxy.findings {host?:string}` → `{type:"findings",findings:[{host,kind,severity,detail,url,flow}]}`. `proxy.clear {}` → `{}`. `proxy.har {query?:string,path?:string}` → `{type:"har",path,text:path}`, writing a local HAR file (default in data dir).
- `proxy.race {id:number,raw?:string,count:number}` → `{type:"race",flows:[flowDetail | {error:string}]}`; sends 1–20 requests concurrently using the same repeat engine. Each successful request becomes a captured flow tagged `repeat`.

The CLI still accepts `bit proxy show <id>`, `repeat <id> --raw file`, `rule-add --where …`, etc., and translates its flag names to these JSON shapes. The service is the only owner of proxy state; the mod/CLI only forward calls.
