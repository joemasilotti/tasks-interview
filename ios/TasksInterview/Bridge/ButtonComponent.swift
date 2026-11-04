import HotwireNative
import UIKit

/// Shows a button in the navigation bar. The page sends the button's title on
/// "connect", and a tap is answered back as a reply to "connect" so the page
/// can act on it.
final class ButtonComponent: BridgeComponent {
    override class var name: String { "button" }

    override func onReceive(message: Message) {
        switch message.event {
        case "connect":
            guard let data: MessageData = message.data() else { return }
            showButton(title: data.title)
        case "disconnect":
            viewController?.navigationItem.rightBarButtonItem = nil
        default:
            break
        }
    }

    private var viewController: UIViewController? {
        delegate?.destination as? UIViewController
    }

    private func showButton(title: String) {
        let action = UIAction { [weak self] _ in
            self?.reply(to: "connect")
        }
        viewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, primaryAction: action)
    }
}

private extension ButtonComponent {
    struct MessageData: Decodable {
        let title: String
    }
}
