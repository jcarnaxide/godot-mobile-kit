extends Node2D


func _on_test_event_pressed():
	MobileKit.log_event("TestEvent", {})
