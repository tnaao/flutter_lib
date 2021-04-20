// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.leaf.fli.nati

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import com.leaf.umxlib.UMXLib
import com.leaf.umxlib.model.UmxLoginResultEvent
import com.leaf.umxlib.model.UmxShareEvent
import com.leaf.umxlib.model.UmxSharePlatEn
import com.leaf.umxlib.model.UmxShareResultEvent

/**
 * Forms and launches intents.
 */
class IntentSender
/**
 * Caches the given `activity` and `applicationContext` to use for sending intents
 * later.
 *
 *
 * Either may be null initially, but at least `applicationContext` should be set before
 * calling [.send].
 *
 *
 * See also [.setActivity], [.setApplicationContext], and [.send].
 */(private var activity: Activity?, private var applicationContext: Context?) {

    /**
     * Creates and launches an intent with the given params using the cached [Activity] and
     * [Context].
     *
     *
     * This will fail to create and send the intent if `applicationContext` hasn't been set
     * at the time of calling.
     *
     *
     * This uses `activity` to start the intent whenever it's not null. Otherwise it falls
     * back to `applicationContext` and adds [Intent.FLAG_ACTIVITY_NEW_TASK] to the intent
     * before launching it.
     */
    fun send(intent: Intent) {
        if (applicationContext == null) {
            Log.wtf(TAG, "Trying to send an intent before the applicationContext was initialized.")
            return
        }
        Log.v(TAG, "Sending intent $intent")
        if (activity != null) {
            activity!!.startActivity(intent)
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            applicationContext!!.startActivity(intent)
        }
    }

    fun doInvoke(task: (ctx: Context) -> Unit) {
        if (activity != null) {
            task(activity!!)
            return
        }
        applicationContext?.let(task)
    }

    fun doLogin(plat: Int, onSucceed: (UmxLoginResultEvent) -> Unit, onError: (String) -> Unit): Boolean {
        if (activity == null) {
            return false
        }
        val platLocal = UmxSharePlatEn.fromCode(plat)
        if (platLocal == UmxSharePlatEn.umverify) {
            UMXLib.umVerify(activity!!, onSucceed = onSucceed, onError = onError)
        } else {
            UMXLib.login(activity!!, platLocal, onSucceed = onSucceed, onError = onError)
        }
        return true
    }

    fun doShare(evt: UmxShareEvent, onSucceed: (UmxShareResultEvent) -> Unit, onError: (UmxShareResultEvent) -> Unit): Boolean {
        if (activity == null) {
            return false
        }
        UMXLib.share(activity!!, evt, onSucceed = {
            val evtLocal = UmxShareResultEvent()
            evtLocal.succeed = true;
            onSucceed(evtLocal)
        }, onError = {
            val evtLocal = UmxShareResultEvent()
            evtLocal.succeed = false;
            evtLocal.errorMsg = it
            onError(evtLocal)
        })
        return true
    }

    /**
     * Verifies the given intent and returns whether the application context class can resolve it.
     *
     *
     * This will fail to create and send the intent if `applicationContext` hasn't been set *
     * at the time of calling.
     *
     *
     * This currently only supports resolving activities.
     *
     * @param intent Fully built intent.
     * @return Whether the package manager found [android.content.pm.ResolveInfo] using its
     * [PackageManager.resolveActivity] method.
     * @see .buildIntent
     */
    fun canResolveActivity(intent: Intent?): Boolean {
        if (applicationContext == null) {
            Log.wtf(TAG, "Trying to resolve an activity before the applicationContext was initialized.")
            return false
        }
        val packageManager = applicationContext!!.packageManager
        return packageManager.resolveActivity(intent!!, PackageManager.MATCH_DEFAULT_ONLY) != null
    }

    /**
     * Caches the given `activity` to use for [.send].
     */
    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    /**
     * Caches the given `applicationContext` to use for [.send].
     */
    fun setApplicationContext(applicationContext: Context?) {
        this.applicationContext = applicationContext
    }

    /**
     * Constructs a new intent with the data specified.
     *
     * @param action        the Intent action, such as `ACTION_VIEW`.
     * @param flags         forwarded to [Intent.addFlags] if non-null.
     * @param category      forwarded to [Intent.addCategory] if non-null.
     * @param data          forwarded to [Intent.setData] if non-null and 'type' parameter is null.
     * If both 'data' and 'type' is non-null they're forwarded to [                      ][Intent.setDataAndType]
     * @param arguments     forwarded to [Intent.putExtras] if non-null.
     * @param packageName   forwarded to [Intent.setPackage] if non-null. This is forced
     * to null if it can't be resolved.
     * @param componentName forwarded to [Intent.setComponent] if non-null.
     * @param type          forwarded to [Intent.setType] if non-null and 'data' parameter is
     * null. If both 'data' and 'type' is non-null they're forwarded to [                      ][Intent.setDataAndType]
     * @return Fully built intent.
     */
    fun buildIntent(
            action: String?,
            flags: Int?,
            category: String?,
            data: Uri?,
            arguments: Bundle?,
            packageName: String?,
            componentName: ComponentName?,
            type: String?): Intent? {
        if (applicationContext == null) {
            Log.wtf(TAG, "Trying to build an intent before the applicationContext was initialized.")
            return null
        }
        val intent = Intent()
        if (action != null) {
            intent.action = action
        }
        if (flags != null) {
            intent.addFlags(flags)
        }
        if (!TextUtils.isEmpty(category)) {
            intent.addCategory(category)
        }
        if (data != null && type == null) {
            intent.data = data
        }
        if (type != null && data == null) {
            intent.type = type
        }
        if (type != null && data != null) {
            intent.setDataAndType(data, type)
        }
        if (arguments != null) {
            intent.putExtras(arguments)
        }
        if (!TextUtils.isEmpty(packageName)) {
            intent.setPackage(packageName)
            if (componentName != null) {
                intent.component = componentName
            }
            if (intent.resolveActivity(applicationContext!!.packageManager) == null) {
                Log.i(TAG, "Cannot resolve explicit intent - ignoring package")
                intent.setPackage(null)
            }
        }
        return intent
    }

    companion object {
        private const val TAG = "IntentSender"
    }

}