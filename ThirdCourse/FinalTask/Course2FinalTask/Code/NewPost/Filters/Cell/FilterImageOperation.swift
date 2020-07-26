import UIKit

class FilterImageOperation: Operation {

    private let image: UIImage
    private let filterType: FilterType
    private(set) var outputImage: UIImage?

    init(image: UIImage, filterType: FilterType) {
        self.image = image
        self.filterType = filterType
    }

    override func main() {
        let context = CIContext()
        guard
            let coreImage = CIImage(image: image),
            let filter = CIFilter(name: filterType.rawValue)
            else {
                return
        }

        filter.setValue(coreImage, forKey: kCIInputImageKey)

        guard
            let filteredImage = filter.outputImage,
            let cgImage = context.createCGImage(filteredImage,
                                                from: filteredImage.extent)
            else {
                return

        }

        outputImage = UIImage(cgImage: cgImage)
    }
}
