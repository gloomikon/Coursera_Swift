//
//  CollectionViewController.swift
//  Course2Week3Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    // MARK: - IBOulets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    // MARK: Private properties

    private var photos: [Photo] = []
    private var photoProvider: PhotoProvider?
    let reuseIdentifier = String(describing: PhotoCollectionViewCell.self)

    // MARK: = Life cycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        generatePhotos()


        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    private func generatePhotos() {
        photoProvider = PhotoProvider()
        photos = (photoProvider?.photos())!
    }

    // MARK: - Private functions

}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: photos[indexPath.row])

        return cell
    }
}
