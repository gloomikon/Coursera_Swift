import UIKit

extension UIViewController {
    func showAlert(title: String = "Unknown error!", message: String = "Please, try again later") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
