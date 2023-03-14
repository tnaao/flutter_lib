package com.umeng.message;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.util.Log;

import com.umeng.message.common.inter.ITagManager;
import com.umeng.message.entity.UMessage;
import com.umeng.message.tag.TagManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.List;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

/**
 * UmengPushSdkPlugin
 */
public class UmengPushSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    public static Function1<Context, Unit> moveToForegroundCall;
    public static Function1<String, Unit> showCallNotificationCall;
    public static Function1<String, Unit> cancelInvitationCall;

    private static final String TAG = "UmengPushSdkPlugin";
    private static boolean isNativeInit = false;
    private static MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "u-push");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "u-push");
        UmengPushSdkPlugin plugin = new UmengPushSdkPlugin();
        plugin.mContext = registrar.context();
        UmengPushSdkPlugin.channel = channel;
        channel.setMethodCallHandler(plugin);
    }

    private static Context mContext = null;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            if (!pushMethodCall(call, result)) {
                result.notImplemented();
            }
        } catch (Exception e) {
            Log.e(TAG, "Exception:" + e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    private boolean pushMethodCall(MethodCall call, Result result) {
        if ("register".equals(call.method)) {
            if (!isNativeInit) {
                register();
            }
            executeOnMain(result, null);
            return true;
        }
        if ("getDeviceToken".equals(call.method)) {
            getDeviceToken(call, result);
            return true;
        }
        if ("enable".equals(call.method)) {
            setPushEnable(call, result);
            return true;
        }
        if ("setAlias".equals(call.method)) {
            setAlias(call, result);
            return true;
        }
        if ("addAlias".equals(call.method)) {
            addAlias(call, result);
            return true;
        }
        if ("removeAlias".equals(call.method)) {
            removeAlias(call, result);
            return true;
        }
        if ("addTag".equals(call.method)) {
            addTags(call, result);
            return true;
        }
        if ("removeTag".equals(call.method)) {
            removeTags(call, result);
            return true;
        }
        if ("getTags".equals(call.method)) {
            getTags(call, result);
            return true;
        }
        return false;
    }

    private void getTags(MethodCall call, final Result result) {
        PushAgent.getInstance(mContext).getTagManager().getTags(new TagManager.TagListCallBack() {
            @Override
            public void onMessage(final boolean b, final List<String> list) {
                if (b) {
                    executeOnMain(result, list);
                } else {
                    executeOnMain(result, Collections.emptyList());
                }
            }
        });
    }

    private void removeTags(MethodCall call, final Result result) {
        List<String> arguments = call.arguments();
        String[] tags = new String[arguments.size()];
        arguments.toArray(tags);
        PushAgent.getInstance(mContext).getTagManager().deleteTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(final boolean b, ITagManager.Result ret) {
                executeOnMain(result, b);
            }
        }, tags);
    }

    private void addTags(MethodCall call, final Result result) {
        List<String> arguments = call.arguments();
        String[] tags = new String[arguments.size()];
        arguments.toArray(tags);
        PushAgent.getInstance(mContext).getTagManager().addTags(new TagManager.TCallBack() {
            @Override
            public void onMessage(final boolean b, ITagManager.Result ret) {
                executeOnMain(result, b);
            }
        }, tags);
    }

    private void removeAlias(MethodCall call, final Result result) {
        String alias = getParam(call, result, "alias");
        String type = getParam(call, result, "type");
        PushAgent.getInstance(mContext).deleteAlias(alias, type, new UTrack.ICallBack() {
            @Override
            public void onMessage(final boolean b, String s) {
                Log.i(TAG, "onMessage:" + b + " s:" + s);
                executeOnMain(result, b);
            }
        });
    }

    private void addAlias(MethodCall call, final Result result) {
        String alias = getParam(call, result, "alias");
        String type = getParam(call, result, "type");
        PushAgent.getInstance(mContext).addAlias(alias, type, new UTrack.ICallBack() {
            @Override
            public void onMessage(boolean b, String s) {
                Log.i(TAG, "onMessage:" + b + " s:" + s);
                executeOnMain(result, b);
            }
        });
    }

    private void setAlias(MethodCall call, final Result result) {
        String alias = getParam(call, result, "alias");
        String type = getParam(call, result, "type");
        PushAgent.getInstance(mContext).setAlias(alias, type, new UTrack.ICallBack() {
            @Override
            public void onMessage(final boolean b, String s) {
                Log.i(TAG, "onMessage:" + b + " s:" + s);
                executeOnMain(result, b);
            }
        });
    }

    private void setPushEnable(MethodCall call, Result result) {
        final boolean enable = call.arguments();
        IUmengCallback callback = new IUmengCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "setPushEnable success:" + enable);
            }

            @Override
            public void onFailure(String s, String s1) {
                Log.i(TAG, "setPushEnable failure:" + enable);
            }
        };
        if (enable) {
            PushAgent.getInstance(mContext).enable(callback);
        } else {
            PushAgent.getInstance(mContext).disable(callback);
        }
        executeOnMain(result, null);
    }

    private void getDeviceToken(MethodCall call, Result result) {
        result.success(PushAgent.getInstance(mContext).getRegistrationId());
    }

    private static boolean launchCheckThenReturn(Context ctx) {
        try {
            ActivityManager am = ((ActivityManager) ctx.getSystemService(Context.ACTIVITY_SERVICE));
            List<ActivityManager.RunningAppProcessInfo> processInfos = am.getRunningAppProcesses();
            String mainProcessName = ctx.getPackageName();
            //获取本App的唯一标识
            int myPid = Process.myPid();

            boolean isForeground = !processInfos.isEmpty() && processInfos.get(0).processName.equals(mainProcessName)
                    && processInfos.get(0).pid == myPid;

            //利用一个增强for循环取出手机里的所有进程
            for (ActivityManager.RunningAppProcessInfo info : processInfos) {
                //通过比较进程的唯一标识和包名判断进程里是否存在该App
                if (info.pid == myPid && info.processName.equals(mainProcessName)) {
                    if (moveToForegroundCall != null) {
                        moveToForegroundCall.invoke(ctx);
                    }
                    return false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Intent var3 = ctx.getPackageManager().getLaunchIntentForPackage(ctx.getPackageName());
        if (var3 != null) {
            var3.setPackage((String) null);
            var3.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            try {
                ctx.startActivity(var3);
            } catch (Exception var5) {
                var5.printStackTrace();
            }

        }
        return true;
    }

    public static void androidRegister(Context app) {
        isNativeInit = true;
        mContext = app;
        register();
    }

    private static void register() {
        final UmengMessageHandler messageHandler = new UmengMessageHandler() {

            @Override
            public void dealWithNotificationMessage(Context context, UMessage uMessage) {
                super.dealWithNotificationMessage(context, uMessage);
                //处理通知栏消息
                Log.i(TAG, "notification receiver:" + uMessage.getRaw().toString());
            }

            @Override
            public void dealWithCustomMessage(Context context, final UMessage uMessage) {
                super.dealWithCustomMessage(context, uMessage);
                Log.i(TAG, "custom m receiver:" + uMessage.getRaw().toString());

                JSONObject msg = uMessage.getRaw();
                try {
                    if (msg.getJSONObject("extra").getString("method").contains("sendLocalInvitation")) {
                        if (showCallNotificationCall != null) {
                            showCallNotificationCall.invoke(msg.getJSONObject("extra").getString("account"));
                        }
                    }
                    if (msg.getJSONObject("extra").getString("method").contains("cancelLocalInvitation")) {
                        if (cancelInvitationCall != null) {
                            cancelInvitationCall.invoke(msg.getJSONObject("extra").getString("account"));
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (launchCheckThenReturn(context)) {
                    return;
                }

                Observable.just("dealWithCustomMessage")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                if (channel != null) {
                                    channel.invokeMethod("onMessage", uMessage.getRaw().toString());
                                }
                            }
                        });

            }
        };

        PushAgent pushAgent = PushAgent.getInstance(mContext);
        //设置客户端允许声音提醒
        pushAgent.setNotificationPlaySound(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
        //设置客户端允许呼吸灯点亮
        pushAgent.setNotificationPlayLights(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
        //设置客户端允许震动
        pushAgent.setNotificationPlayVibrate(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
        //设置冷却时间，避免三分钟内出现多条通知而被替换
        pushAgent.setMuteDurationSeconds(180);
        pushAgent.setNotificationOnForeground(true);
        pushAgent.setResourcePackageName(BuildConfig.LIBRARY_PACKAGE_NAME);
        PushAgent.getInstance(mContext).setMessageHandler(messageHandler);
        pushAgent.setNotificationClickHandler(new UmengNotificationClickHandler() {
            @Override
            public void handleMessage(Context context, final UMessage uMessage) {
                if (launchCheckThenReturn(mContext)) {
                    return;
                }

                Observable.just("dealWithCustomMessage")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                if (channel != null) {
                                    channel.invokeMethod("onMessage", uMessage.getRaw().toString());
                                }
                            }
                        });
            }
        });
        PushAgent.getInstance(mContext).register(new IUmengRegisterCallback() {
            @Override
            public void onSuccess(final String deviceToken) {
                Log.i(TAG, "register success deviceToken:" + deviceToken);

                Observable.just("register deviceToken")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                PushAgent.getInstance(mContext).onAppStart();
                                if (channel != null) {
                                    channel.invokeMethod("onToken", deviceToken);
                                }
                            }
                        });
            }

            @Override
            public void onFailure(String s, String s1) {
                Log.i(TAG, "register failure s:" + s + " s1:" + s1);
            }
        });

        new Thread(new Runnable() {
            @Override
            public void run() {
                PushAgent pushAgent = PushAgent.getInstance(mContext);
                pushAgent.setDisplayNotificationNumber(0);
                pushAgent.setNotificationOnForeground(true);
                //设置客户端允许声音提醒
                pushAgent.setNotificationPlaySound(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
                //设置客户端允许呼吸灯点亮
                pushAgent.setNotificationPlayLights(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
                //设置客户端允许震动
                pushAgent.setNotificationPlayVibrate(MsgConstant.NOTIFICATION_PLAY_SDK_ENABLE);
                //设置冷却时间，避免三分钟内出现多条通知而被替换
                pushAgent.setMuteDurationSeconds(180);
                pushAgent.setNotificationOnForeground(true);
                pushAgent.setResourcePackageName(BuildConfig.LIBRARY_PACKAGE_NAME);
                PushAgent.getInstance(mContext).setMessageHandler(messageHandler);
                pushAgent.setNotificationClickHandler(new UmengNotificationClickHandler() {
                    @Override
                    public void handleMessage(Context context, final UMessage uMessage) {
                        if (launchCheckThenReturn(mContext)) {
                            return;
                        }

                        Observable.just("dealWithCustomMessage")
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(new Consumer<String>() {
                                    @Override
                                    public void accept(String s) throws Exception {
                                        if (channel != null) {
                                            channel.invokeMethod("onMessage", uMessage.getRaw().toString());
                                        }
                                    }
                                });
                    }
                });
                PushAgent.getInstance(mContext).register(new IUmengRegisterCallback() {
                    @Override
                    public void onSuccess(final String deviceToken) {
                        Log.i(TAG, "register success deviceToken:" + deviceToken);
                    }

                    @Override
                    public void onFailure(String s, String s1) {
                        Log.i(TAG, "register failure s:" + s + " s1:" + s1);
                    }
                });
            }
        }).start();

        //推送消息点击处理
        UmengNotificationClickHandler notificationClickHandler = new UmengNotificationClickHandler() {
            @Override
            public void openActivity(Context context, final UMessage msg) {
                super.openActivity(context, msg);
                Log.i(TAG, "click openActivity: " + msg.getRaw().toString());
                Observable.just("onNotify")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                if (channel != null) {
                                    channel.invokeMethod("onNotify", msg.getRaw().toString());
                                }
                            }
                        });
            }

            @Override
            public void dealWithCustomAction(Context context, final UMessage uMessage) {
                super.dealWithCustomAction(context, uMessage);
                Log.i(TAG, "click dealWithCustomAction: " + uMessage.getRaw().toString());
                Observable.just("onNotify")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                if (channel != null) {
                                    channel.invokeMethod("onNotify", uMessage.getRaw().toString());
                                }
                            }
                        });
            }

            @Override
            public void launchApp(Context context, final UMessage msg) {
                super.launchApp(context, msg);
                Log.i(TAG, "click launchApp: " + msg.getRaw().toString());
                Observable.just("onNotify")
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Consumer<String>() {
                            @Override
                            public void accept(String s) throws Exception {
                                if (channel != null) {
                                    channel.invokeMethod("onNotify", msg.getRaw().toString());
                                }
                            }
                        });
            }

            @Override
            public void dismissNotification(Context context, UMessage msg) {
                super.dismissNotification(context, msg);
                Log.i(TAG, "click dismissNotification: " + msg.getRaw().toString());
            }
        };
        pushAgent.setNotificationClickHandler(notificationClickHandler);
    }

    private final Handler mHandler = new Handler(Looper.getMainLooper());

    private static void executeOnMain(final Result result, final Object param) {
        Observable.just("upush-" + System.currentTimeMillis())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        result.success(param);
                    }
                });
    }

    public static <T> T getParam(MethodCall methodCall, MethodChannel.Result result, String param) {
        T value = methodCall.argument(param);
        if (value == null) {
            result.error("missing param", "cannot find param:" + param, 1);
        }
        return value;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mContext = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        mContext = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        mContext = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        mContext = null;
    }

    //-----  PUSH END -----
}
