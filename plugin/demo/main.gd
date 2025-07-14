extends Node2D


func _on_test_event_pressed():
	MobileKit.log_event("TestEvent", {})


func _on_test_crash_pressed():
	MobileKit.test_crash("TestCrash")
