import UIKit

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Unknown error!", message: "Please, try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
