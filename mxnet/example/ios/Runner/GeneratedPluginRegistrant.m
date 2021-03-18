//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<mxnet/MxnetPlugin.h>)
#import <mxnet/MxnetPlugin.h>
#else
@import mxnet;
#endif

#if __has_include(<shared_preferences/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [MxnetPlugin registerWithRegistrar:[registry registrarForPlugin:@"MxnetPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end
