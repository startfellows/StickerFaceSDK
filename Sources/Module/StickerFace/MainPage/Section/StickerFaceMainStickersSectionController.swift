import UIKit
import IGListKit

class StickerFaceMainStickersSectionController: ListSectionController {
    
    var sticker: StickerFaceMainSticker!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 116.0, right: 16.0)
        minimumInteritemSpacing = 12.0
        minimumLineSpacing = 12.0
        supplementaryViewSource = self
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is StickerFaceMainSticker)
        sticker = object as? StickerFaceMainSticker
    }
    
    override func numberOfItems() -> Int {
        return 29
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(side: (collectionContext!.insetContainerSize.width - 16 - 12 - 16)/2)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: StickerFaceMainStickersCell.self, for: self, at: index)
        
        let layers = "s\(index + 1);" + sticker.layers
        ImageLoader.setImage(layers: layers, imgView: cell.imageView, size: 163)
        
        return cell
    }
    
}

// MARK: - ListSupplementaryViewSource
extension StickerFaceMainStickersSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let view = collectionContext!.dequeue(ofKind: UICollectionElementKindSectionHeader, for: self, of: StickerFaceMainStickersHeaderView.self, at: index)
        view.titleLabel.text = "Stickers"
        
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 46.0)
    }
    
}
