//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_native_player/FlutterNativePlayerPlugin.h>)
#import <flutter_native_player/FlutterNativePlayerPlugin.h>
#else
@import flutter_native_player;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<mxbase/MxbasePlugin.h>)
#import <mxbase/MxbasePlugin.h>
#else
@import mxbase;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<webview_flutter/FLTWebViewFlutterPlugin.h>)
#import <webview_flutter/FLTWebViewFlutterPlugin.h>
#else
@import webview_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterNativePlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNativePlayerPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [MxbasePlugin registerWithRegistrar:[registry registrarForPlugin:@"MxbasePlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
