@tool
class_name MobileKitEditorPlugin
extends EditorPlugin

const _plugin_name = "MobileKit"

const FIREBASE_PLUGINS := """\n        \
//Firebase plugins\n        \
id 'com.google.gms.google-services' version '4.4.3'\n        \
id 'com.google.firebase.crashlytics' version '3.0.4'\n
"""

# A class member to hold the editor export plugin during its lifecycle.
var export_plugin : AndroidExportPlugin


static func _cleanup_plugin() -> void:
	if FileAccess.file_exists("res://android/build/build.gradle"):
		var file := FileAccess.open("res://android/build/build.gradle", FileAccess.READ)
		var file_text := file.get_as_text()
		file.close()
		file_text = file_text.replace(FIREBASE_PLUGINS, "")
		file = FileAccess.open("res://android/build/build.gradle", FileAccess.WRITE)
		file.store_string(file_text)
		file.close()


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


func _disable_plugin() -> void:
	_cleanup_plugin()


class AndroidExportPlugin extends EditorExportPlugin:
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		if features.has("android"):
			if not get_option("gradle_build/use_gradle_build")\
				or not FileAccess.file_exists("res://android/build/google-services.json"):
				MobileKitEditorPlugin._cleanup_plugin()
				return
			var file := FileAccess.open("res://android/build/build.gradle", FileAccess.READ)
			var file_text := file.get_as_text()
			file.close()
			if not file_text.contains("//Firebase plugins"):
				var search_text := "id 'org.jetbrains.kotlin.android'\n"
				file_text = file_text.replace(search_text, search_text + FIREBASE_PLUGINS)
				file = FileAccess.open("res://android/build/build.gradle", FileAccess.WRITE)
				file.store_string(file_text)
				file.close()


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
