//
//  NoljanoljaApp.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import SwiftUI

@main
struct MainApp {
    static func main() {
        if #available(iOS 14.0, *) {
            NoljanoljaApp.main()
        } else {
            UIApplicationMain(
                CommandLine.argc,
                CommandLine.unsafeArgv,
                nil,
                NSStringFromClass(AppDelegate.self)
            )
        }
    }
}

@available(iOS 14.0, *)
struct NoljanoljaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
