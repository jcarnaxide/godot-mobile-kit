extends Node2D

var _plugin_name = "MobileKit"
var _android_plugin

func _on_Button_pressed():
	MobileKit.log_event("TestEvent", {})
