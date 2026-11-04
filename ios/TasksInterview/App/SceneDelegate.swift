import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigator = Navigator(configuration: .init(name: "main", startLocation: Self.serverURL))

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigator.rootViewController
        window?.makeKeyAndVisible()
        navigator.start()
    }

    // Set SERVER_URL in the scheme's environment variables when the Rails server
    // isn't on port 3000.
    private static var serverURL: URL {
        let configured = ProcessInfo.processInfo.environment["SERVER_URL"]
        return URL(string: configured ?? "http://localhost:3000")!
    }
}
