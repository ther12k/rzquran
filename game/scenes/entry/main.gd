extends Control
## Composition root — the ONLY place that selects a platform adapter.
## Shared scenes and services depend on platform/platform_client.gd alone;
## adapters are loaded dynamically so no shared scene imports web-only code.
## References use preload/path, never class_name (see platform_client.gd).

const PLATFORM_BASE := preload("res://platform/platform_client.gd")
const KIDS_THEME: Theme = preload("res://theme/rzq_kids_theme.tres")

var _client: PLATFORM_BASE


func _ready() -> void:
	theme = KIDS_THEME
	_client = _make_client()
	(%BuildLabel as Label).text = "Build %s" % BuildInfo.build_id
	(%PlatformLabel as Label).text = "Platform: %s" % _client.platform_name()
	# Development visibility of the build identity (GDM-002).
	print("[rzq-kids] build=%s platform=%s" % [BuildInfo.build_id, _client.platform_name()])


func _make_client() -> PLATFORM_BASE:
	if OS.has_feature("web"):
		return load("res://platform/web/web_client.gd").new() as PLATFORM_BASE
	return load("res://platform/native/native_client.gd").new() as PLATFORM_BASE
