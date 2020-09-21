import UIKit
import Flutter
import HomeKit
import Foundation

enum ChannelName {
  static let actionCh = "com.channel.app/actionset"
    static let homeCh = "com.channel.app/home"
  static let eventCh = "com.channel.app/eventus"
}

enum BatteryState {
  static let charging = "charging"
  static let discharging = "discharging"
}

enum MyFlutterErrorCode {
  static let unavailable = "UNAVAILABLE"
}


@available(iOS 11.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
   private var eventSink: FlutterEventSink?
    
    var homeDataStore = HomeData()
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
    guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
    }
   
    let  homeChannel = FlutterMethodChannel(name:ChannelName.homeCh,binaryMessenger: controller.binaryMessenger)
    
    homeChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        switch call.method {
        
        case "getHome":
        self?.homeDataStore.getHomes(result:result)
        print("Poluchili Dom")
        
        case "getActions":
        print("Poluchili Scenes")
        self?.homeDataStore.getActionList(result:result)
            
       /* case "getTriggers":
        print("Poluchili triggers")
        self?.homeDataStore.getListOfTrigger(result:result)*/
       
        case "createTrigger":
            let h: Array = call.arguments as! Array<Any>
            
            guard let opp: Any = self?.homeDataStore.createNewTrigger(name: h[0] as! String, weekdays: h[1] as! [Int], hour: h[2] as! Int, minute: h[3] as! Int, sceneName: h[4] as! String, boolShit: h[5] as! Bool)
            else {
            print("nothing")
                return
                
            }
            print(opp as Any)
            print(h.description)
            
        case "switchTrigger":
            let switchOn = call.arguments as! String
            self?.homeDataStore.switchbitch(name: switchOn)
       
        case "getNameTrigger" :
            print("Poluchili names")
            self?.homeDataStore.getNameTrigger(result: result)
        case "getTimeTrigger" :
            print("Poluchili time")
            self?.homeDataStore.getTimeTrigger(result: result)
        
        
        case "deleteTrigger":
            let delete = call.arguments as! String
            self?.homeDataStore.deleteTrigger(namus: delete)
            
        case "deleteAll":
            self?.homeDataStore.deleteAll()
        default :
        result(FlutterMethodNotImplemented)
        
    }
    })
    
   
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    
   
   
    
}








