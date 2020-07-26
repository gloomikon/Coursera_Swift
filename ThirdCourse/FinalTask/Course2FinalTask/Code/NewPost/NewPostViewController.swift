import UIKit

class NewPostViewController: BaseViewController {
    private enum Constants {
        static let goToFiltersSegue = "goToFiltersViewController"
    }

    // MARK: - IBOutlets

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    @IBOutlet var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Properties

    private let segueHandler = SegueHandler()
    private let cellId = String(describing: PostCell.self)
    private var photos: [UIImage] = []
    private var thumbnailPhotos: [UIImage] = []

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        KDataProvider.showLoaderView()

        KDataProvider.photos()
            .zip(KDataProvider.thumbnailPhotos())
            .onSuccess { [weak self] photos, thumbnailPhotos in
                guard let self = self else {
                    return
                }
                self.flowLayout.minimumLineSpacing = .zero
                self.flowLayout.minimumInteritemSpacing = .zero
                self.flowLayout.itemSize = CGSize(width: self.view.bounds.size.width / 3, height: self.view.bounds.size.width / 3)
                self.photos = photos
                self.thumbnailPhotos = thumbnailPhotos
                self.collectionView.reloadData()
                KDataProvider.hideLoaderView()
        }
        .onFailure { [weak self] error in
            KDataProvider.hideLoaderView()
            self?.showAlert()
        }

        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
}

// MARK: - UICollectionViewDelegate

extension NewPostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        segueHandler.perform(from: self, identifier: Constants.goToFiltersSegue) { [weak self] viewController in
            if let viewController = viewController as? FiltersViewController {
                guard let self = self else {
                    return
                }

                viewController.configure(with: self.photos[indexPath.row], and: self.thumbnailPhotos[indexPath.row])
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NewPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PostCell else {
            return .init()
        }

        cell.configure(with: photos[indexPath.row])
        return cell
    }
}

// MARK: - DescriptionDelegate

extension NewPostViewController: DescriptionDelegate {
    func handlePostAdding() {
        navigationController?.popToRootViewController(animated: false)
        if let viewController = tabBarController?.viewControllers?.first?.children.first as? FeedViewController {
            viewController.updatePosts()
        }
                if let viewController = tabBarController?.viewControllers?[2].children.first as? ProfileViewController {
            viewController.updatePosts()
        }
        tabBarController?.selectedIndex = 0
    }
}
