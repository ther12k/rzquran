extends "res://platform/platform_client.gd"
## Native adapter: HTTPS to the existing API with the staging-only grant flow,
## per docs/godot-mvp/architecture/platform-auth.md. Loaded ONLY by the
## composition root on non-web platforms; no web-only singletons are touched.
## Transport + staging pairing implementation arrives with GDM-009.


func platform_name() -> String:
	return "native-https"
