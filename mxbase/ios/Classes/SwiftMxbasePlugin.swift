import Flutter
import UIKit
import CoreBluetooth


public class SwiftMxbasePlugin: NSObject, FlutterPlugin,CBPeripheralManagerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mxbase", binaryMessenger: registrar.messenger())
    let instance = SwiftMxbasePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  open func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "exitApp" {
          exit(0)
          result(nil)
      }

      if call.method == "blePermissionCheck" {
          let showPermissionAlert = true
        let options = [CBCentralManagerOptionShowPowerAlertKey: showPermissionAlert]
        let bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
      }
      
      if call.method == "grassJson" {
          guard let bytesData = call.arguments as? FlutterStandardTypedData else {
                result(nil)
                return
              }
          let uint8List = bytesData.data // Access the Data (Swift's equivalent of Uint8List)
          guard let data = uint8List as NSData? as Data? else {
              result(nil)
              return
          }
          do {
              let packet = try Fibot_AICProtocol_AIC_ProtocolFrame(jsonUTF8Data: data)
              result(nil)
          }catch {
              result(nil)
          }
      }
  }
}
