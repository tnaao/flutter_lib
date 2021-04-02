#import "NatiPlugin.h"
#if __has_include(<nati/nati-Swift.h>)
#import <nati/nati-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nati-Swift.h"
#endif

@implementation NatiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNatiPlugin registerWithRegistrar:registrar];
}
@end
