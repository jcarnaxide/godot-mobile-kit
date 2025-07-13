extends Node

var _plugin_name = "MobileKit"
var _singleton: Object


func _ready() -> void:
	if Engine.has_singleton(_plugin_name):
		_singleton = Engine.get_singleton(_plugin_name)
	else:
		push_warning("Couldn't find " + _plugin_name)


func log_event(event: String, params: Dictionary) -> void:
	if _singleton:
		_singleton.logEvent(event, params)


func set_analytics_collection_enabled(enabled: bool) -> void:
	if _singleton:
		_singleton.setAnalyticsCollectionEnabled(enabled)
