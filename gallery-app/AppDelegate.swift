import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let galleryVC = GalleryViewController()
        
        _ = galleryVC.view

        let navVC = UINavigationController(rootViewController: galleryVC)
        window?.rootViewController = navVC
        
        window?.makeKeyAndVisible()

        print("AppDelegate: Window запущено")
        print("rootVC:", window?.rootViewController ?? "нет rootViewController")

        return true
    }
}



