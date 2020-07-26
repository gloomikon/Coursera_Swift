import UIKit
import DataProvider

class PostCell: UICollectionViewCell {
    @IBOutlet private var postImage: UIImageView!

    func configure(with post: Post) {
        postImage.image = post.image
    }

    func configure(with image: UIImage) {
        postImage.image = image
    }
}
