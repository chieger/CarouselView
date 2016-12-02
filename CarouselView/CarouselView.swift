//
//  CarouselView.swift
//  CarouselView
//
//  Created by Charles Hieger on 12/1/16.
//  Copyright © 2016 Charles Hieger. All rights reserved.
//

import UIKit

@objc protocol CarouselViewDelegate: UICollectionViewDelegate {
    @objc optional func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int)
}

@objc protocol CarouselViewDataSource {
    func carouselView(_ carouselView: CarouselView, numberOfItemsInSection section: Int) -> Int

    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class CarouselView: UIView {

    weak var delegate: CarouselViewDelegate?
    weak var dataSource: CarouselViewDataSource?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var showsIndicatorDots: Bool = true

    func reloadData() {

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    private func initSubviews() {
        let xib = UINib(nibName: "CarouselView", bundle: Bundle(for: type(of: self)))
        xib.instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}


extension CarouselView: UICollectionViewDelegate {
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        collectionView.scrollToItem(at:, at: UICollectionViewScrollPosition, animated: Bool)
//    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView?(self, didSelectItemAt: indexPath.item)
    }
}

extension CarouselView: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let bufferSectionsPerSide = 1
        if let items = dataSource?.carouselView(self, numberOfItemsInSection: section) {
            return items * bufferSectionsPerSide * 3
        } else {
            return 0
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let adjustedIndexPathItem = indexPath.row % dataSource!.carouselView(self, numberOfItemsInSection: 0)
        let indexPath = IndexPath(item: adjustedIndexPathItem, section: 0)
        return dataSource!.carouselView(self, cellForItemAt: indexPath)
    }
}


extension CarouselView: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




