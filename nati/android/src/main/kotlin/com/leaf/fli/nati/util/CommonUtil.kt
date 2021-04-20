package com.leaf.fli.nati.util

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager

object CommonUtil {
    fun hideInput(activity: Context) {
        if (activity is Activity) {
            if (activity.window.attributes.softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
                val focusView = activity.currentFocus;
                if (focusView != null) {
                    val imm = activity.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
                    imm.hideSoftInputFromWindow(focusView.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)
                }
            }
        }
    }

    fun getAppVersionName(context: Context): String {
        var versionName = ""
        try {
            val pm = context.packageManager
            val pi = pm.getPackageInfo(context.packageName, 0)
            versionName = pi.versionName
            if (versionName == null || versionName.length <= 0) {
                return ""
            }
        } catch (e: Exception) {
            Log.e("VersionInfo", "CommonUtils", e)
        }
        return versionName
    }

    fun getAppVersionCode(context: Context): Int {
        var versionCode = 0
        try {
            val pm = context.packageManager
            val pi = pm.getPackageInfo(context.packageName, 0)
            versionCode = pi.versionCode
        } catch (e: Exception) {
            Log.e("VersionInfo", "CommonUtils", e)
        }
        return versionCode
    }
}