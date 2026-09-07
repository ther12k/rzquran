extends "res://platform/platform_client.gd"
## Web adapter: same-origin host bridge (JavaScriptBridge), per
## docs/godot-mvp/architecture/platform-auth.md. This script is loaded ONLY by
## scenes/entry/main.gd (the composition root) when running on the web
## platform; shared scenes never reference it, so native builds pack but never
## execute it. Transport implementation arrives with GDM-008.


func platform_name() -> String:
	return "web-host-bridge"
