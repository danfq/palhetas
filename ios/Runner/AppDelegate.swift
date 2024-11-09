import UIKit
import Flutter
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    //Register Self
    GeneratedPluginRegistrant.register(with: self)

    //Set WorkManager Time Interval - 1 Hour
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(3600))

    //Make Other Plugins Available During a Background Fetch
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
