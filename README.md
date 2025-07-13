### Building the configured Android plugin
- In a terminal window, navigate to the project's root directory and run the following command:
```
.\gradlew assemble
```
- On successful completion of the build, the output files can be found in
  [`plugin/demo/addons`](plugin/demo/addons)

### Testing the Android plugin
You can use the included [Godot demo project](plugin/demo/project.godot) to test the built Android 
plugin

- Open the demo in Godot (4.4 or higher)
- Navigate to `Project` -> `Project Settings...` -> `Plugins`, and ensure the plugin is enabled
- Install the Godot Android build template by clicking on `Project` -> `Install Android Build Template...`
- Add your `google-services.json` file to your `res://android/build` directory.
- Connect an Android device to your machine and run the demo on it

### Debugging Firebase Analytics
If you want to enable faster caputre of analytics, set debug capture on your device.
```
adb shell setprop debug.firebase.analytics.app com.carnaxide_games.mobile_kit_demo
```

#### Tips
Additional dependencies added to [`plugin/build.gradle.kts`](plugin/build.gradle.kts) should be added to the `_get_android_dependencies`
function in [`plugin/export_scripts_template/export_plugin.gd`](plugin/export_scripts_template/export_plugin.gd).
