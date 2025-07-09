package com.carnaxide_games.mobile_kit

import android.app.Activity
import android.util.Log
import android.view.View
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.UsedByGodot
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.analytics.logEvent
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.google.firebase.crashlytics.ktx.crashlytics
import com.google.firebase.ktx.Firebase
import org.godotengine.godot.Dictionary

class GodotAndroidPlugin(godot: Godot): GodotPlugin(godot) {
    private val _TAG = BuildConfig.GODOT_PLUGIN_NAME

    override fun getPluginName() = BuildConfig.GODOT_PLUGIN_NAME
    private lateinit var firebaseAnalytics: FirebaseAnalytics
    private lateinit var firebaseCrashlytics: FirebaseCrashlytics

    override fun onMainCreate(activity: Activity?): View? {
        // Obtain the FirebaseAnalytics instance.
        firebaseAnalytics = Firebase.analytics
        firebaseCrashlytics = Firebase.crashlytics
        return super.onMainCreate(activity)
    }

    @UsedByGodot
    private fun logEvent(event: String, params: Dictionary) {
        firebaseAnalytics.logEvent(event) {
            for (i in params){
                when (val value: Any = i.value as Any) {
                    is Long -> {
                        param(i.key, value)
                    }

                    is Int -> {
                        param(i.key, value.toLong())
                    }

                    is String -> {
                        param(i.key, value)
                    }

                    is Double -> {
                        param(i.key, value)
                    }
                }
            }
        }
    }

    @UsedByGodot
    private fun setAnalyticsCollectionEnabled(enabled: Boolean) {
        Log.d(_TAG, (if (enabled) "Enabling" else "Disabling") + " analytics collection")
        firebaseAnalytics.setAnalyticsCollectionEnabled(enabled)
        firebaseCrashlytics.isCrashlyticsCollectionEnabled = enabled
        Log.d(_TAG, "Analytics collection " + (if (enabled) "enabled" else "disabled"))
    }

    @UsedByGodot
    private fun testCrash(msg: String = "testCrash") {
        Log.d(_TAG, "Testing crash with msg=$msg")
        throw RuntimeException(msg)
    }

    @UsedByGodot
    private fun testCrashForceUpload(msg: String = "testCrash") {
        Log.d(_TAG, "Testing crash with msg=$msg")
        val isEnabled = firebaseCrashlytics.isCrashlyticsCollectionEnabled
        Log.d(_TAG, "isCrashlyticsEnabled=$isEnabled")
        firebaseCrashlytics.recordException(RuntimeException(msg))
    }
}