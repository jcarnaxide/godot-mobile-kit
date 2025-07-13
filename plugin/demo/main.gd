extends Node2D


func _on_test_event_pressed():
	MobileKit.log_event("TestEvent", {})


func _crash():
	_crash()


func _on_test_crash_pressed():
	_crash()
