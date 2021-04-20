package com.leaf.fli.nati

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result


enum class NatiMethodEn(val method: String) {
    hideKeyboard("HideKeyboard"),
    appversion("AppVersion"),
    share("Share"),
    login("Login");
}

class LoginEvent(var plat: Int? = 0)

class NatiPlugin : FlutterPlugin, ActivityAware {

    companion object {
        @JvmField
        val CHANNEL_NAME = "com.leaf.fli/nati"
    }

    private var sender: IntentSender? = null
    private var impl: MethodCallHandlerImpl? = null

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    init {
        sender = IntentSender( /*activity=*/null,  /*applicationContext=*/null)
        impl = MethodCallHandlerImpl(sender)
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        sender?.setApplicationContext(flutterPluginBinding.applicationContext)
        sender?.setActivity(null)
        impl?.startListening(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        sender?.setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        sender?.setActivity(binding.activity)
        impl?.let {
            binding.addActivityResultListener(it)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
