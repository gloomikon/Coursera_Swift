import UIKit

enum FilterType : String, CaseIterable {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

class FiltersViewController: BaseViewController {
    private enum Constants {
        static let goToDescriptionSegue = "goToDescriptionViewController"
    }

    // MARK: - IBOutlets

    @IBOutlet var photoImageView: UIImageView!

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    @IBOutlet var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 16
            flowLayout.minimumInteritemSpacing = .zero
            flowLayout.itemSize = CGSize(width: 120.0, height: 100.0)
        }
    }

    // MARK: - Properties

    private let filters = FilterType.allCases
    private var filteredImages: [FilterType: UIImage?] = [:]
    private let cellId = String(describing: FilterImageCell.self)
    private var photo: UIImage!
    private var thumbnailPhoto: UIImage!
    private let segueHandler = SegueHandler()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = photo

        collectionView.register(UINib(nibName: "FilterImageCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        beginImageFiltering()
    }

    // MARK: - Configure

    func configure(with photo: UIImage, and thumbnailPhoto: UIImage) {
        self.photo = photo
        self.thumbnailPhoto = thumbnailPhoto
    }

    // MARK: - IBActions

    @IBAction func nextButtonTapped(_ sender: Any) {
        segueHandler.perform(from: self, identifier: Constants.goToDescriptionSegue) { [weak self] viewController in
            if let viewController = viewController as? DescriptionViewController,
                let image = self?.photoImageView.image {
                viewController.configure(with: image)
            }
        }
    }

    // MARK: - Functions

    private func beginImageFiltering() {
        let queue = OperationQueue()

        for filter in filters {
            let operation = FilterImageOperation(image: thumbnailPhoto, filterType: filter)

            operation.completionBlock = {
                DispatchQueue.main.async {
                    self.filteredImages[filter] = operation.outputImage
                    self.collectionView.reloadData()
                }
            }

            queue.addOperation(operation)
        }
    }

    private func applyFilter(_ filterType: FilterType) {
        let queue = OperationQueue()

        let operation = FilterImageOperation(image: photo, filterType: filterType)

        operation.completionBlock = {
            DispatchQueue.main.async {
                self.photoImageView.image = operation.outputImage
                KDataProvider.hideLoaderView()
            }
        }

        KDataProvider.showLoaderView()
        queue.addOperation(operation)
    }
}

// MARK: - UICollectionViewDelegate

extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        applyFilter(filters[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FilterImageCell else {
            return UICollectionViewCell()
        }

        cell.setFilterType(filters[indexPath.row])
        if let filteredImage = filteredImages[filters[indexPath.row]] {
            cell.setFilteredImage(filteredImage)
        }
        return cell
    }
}
