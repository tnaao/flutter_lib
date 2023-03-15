package io.agora.agorartm

import android.annotation.SuppressLint
import android.content.Context
import com.leaf.mxnetlib.base.BaseEventTaskHandler
import io.agora.rtm.ErrorInfo
import io.agora.rtm.ResultCallback

sealed class RtmEvent {
    class Release() : RtmEvent()
}

class RtmEventHandler(context: Context) : BaseEventTaskHandler<RtmEvent>(context) {

    private object Holder {
        @SuppressLint("StaticFieldLeak")
        var instance: RtmEventHandler? = null
    }

    companion object {
        const val TAG = "RtmEventHandler"

        fun getInstance(context: Context): RtmEventHandler {
            if (Holder.instance == null) {
                Holder.instance = RtmEventHandler(context)
            }
            return Holder.instance!!
        }
    }

    override val workInterval: Long
        get() = -1

    override fun handle(it: RtmEvent) {
        when (it) {
            is RtmEvent.Release -> {
                xRelease()
            }
        }
    }

    fun xRelease() {
        AgoraRtmPlugin.clients.values.forEach {
            try {
                it.client.logout(object : ResultCallback<Void> {
                    override fun onSuccess(p0: Void?) {
                        it.client.release()
                        "logout success".let {

                        }
                    }

                    override fun onFailure(p0: ErrorInfo?) {
                        "logout failed ${p0?.errorDescription}".let {

                        }
                    }

                })
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}