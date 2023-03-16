package com.example.flutter_file_downloader.core

import com.allenliu.versionchecklib.Download
import com.allenliu.versionchecklib.xOkHttpClientDownload
import com.allenliu.versionchecklib.xSslFactoryCustom
import okhttp3.OkHttpClient
import java.io.File
import java.util.concurrent.TimeUnit


object FileUtil {

    val flutterFileDownloaderClient = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.MINUTES)
        .readTimeout(30, TimeUnit.MINUTES)
        .apply {
            xSslFactoryCustom()
        }
        .build()

    fun downloadFile(url: String, savePath: String, callbacks: DownloadCallbacks) {
        val saveFile = File(savePath)
        val dir = saveFile.parentFile
        if (!dir.exists()) {
            dir.mkdirs()
        }
        if (saveFile.exists()) {
            saveFile.delete()
        }
        flutterFileDownloaderClient.xOkHttpClientDownload(url, dir!!, saveFile.name) {
            when (it) {
                is Download.Failed -> {
                    callbacks.onDownloadError(it.msg)
                }

                is Download.Finished -> {
                    callbacks.onDownloadCompleted(it.file.absolutePath)
                }

                is Download.Progress -> {
                    callbacks.onProgress(it.percent.toDouble())
                    callbacks.onProgress(saveFile.name, it.percent.toDouble())
                }
            }
        }
    }
}