@tool
extends EditorPlugin

const _plugin_name = "MobileKit"

# A class member to hold the editor export plugin during its lifecycle.
var export_plugin : AndroidExportPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)
	add_autoload_singleton(_plugin_name, "mobile_kit.gd")


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_export_plugin(export_plugin)
	export_plugin = null
	remove_autoload_singleton(_plugin_name)


class AndroidExportPlugin extends EditorExportPlugin:
	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			if not get_option("gradle_build/use_gradle_build"):
				push_warning("%s not added cause you don't use gradle build" % _plugin_name)
				return false
			if not FileAccess.file_exists("res://android/build/google-services.json"):
				push_warning("%s not added cause file res://android/build/google-services.json not found" % _plugin_name)
				return false
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([_plugin_name + "/bin/debug/" + _plugin_name + "-debug.aar"])
		else:
			return PackedStringArray([_plugin_name + "/bin/release/" + _plugin_name + "-release.aar"])

	func _get_android_dependencies(platform, debug):
		return PackedStringArray([
			"com.google.firebase:firebase-analytics:22.5.0",
			"com.google.firebase:firebase-crashlytics:19.4.4",
		])

	func _get_name():
		return _plugin_name
