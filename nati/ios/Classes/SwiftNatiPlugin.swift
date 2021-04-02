import Flutter
import UIKit

public class SwiftNatiPlugin: NSObject, FlutterPlugin {
    static let CHANNEL_NAME = "com.leaf.fli/nati"
    
    public static var viewController = UIViewController()
    var pendingResult:FlutterResult!
  public static func register(with registrar: FlutterPluginRegistrar) {
    viewController = (UIApplication.shared.delegate?.window??.rootViewController)!
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftNatiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    pendingResult = result
    result("iOS " + UIDevice.current.systemVersion)
  }
}
