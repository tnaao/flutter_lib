#import "MxbasePlugin.h"
#if __has_include(<mxbase/mxbase-Swift.h>)
#import <mxbase/mxbase-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mxbase-Swift.h"
#endif

@implementation MxbasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMxbasePlugin registerWithRegistrar:registrar];
}
@end
