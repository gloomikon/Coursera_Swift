import UIKit

protocol DescriptionDelegate: class {
    func handlePostAdding()
}

class DescriptionViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!

    // MARK: - Properties

    private var image: UIImage!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }

    // MARK: - Configure

    func configure(with image: UIImage) {
        self.image = image
    }

    // MARK: - IBActions

    @IBAction func shareButtonTapped(_ sender: Any) {
        guard
            let image = imageView.image,
            let description = textField.text
        else {
            return
        }

        KDataProvider.showLoaderView()
        KDataProvider.newPost(with: image, description: description)
            .onSuccess { [weak self] post in
                KDataProvider.hideLoaderView()
                if let delegate = self?.navigationController?.viewControllers.first as? DescriptionDelegate {
                    delegate.handlePostAdding()
                }
        }
        .onFailure { [weak self] error in
            KDataProvider.hideLoaderView()
            self?.showAlert()
        }
    }
}
