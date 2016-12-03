//
//  CarouselView.swift
//  CarouselView
//
//  Created by Charles Hieger on 12/1/16.
//  Copyright © 2016 Charles Hieger. All rights reserved.
//

import UIKit

@objc protocol CarouselViewDelegate: UICollectionViewDelegate {
    @objc optional func carouselView(carouselView: CarouselView, didSelectItemAt index: Int)
}

@objc protocol CarouselViewDataSource {
    func numberOfItems(in carouselView: CarouselView) -> Int

    func carouselView(carouselView: CarouselView, cellForItemAt index: Int) -> UICollectionViewCell
}

class CarouselView: UIView {

    weak var delegate: CarouselViewDelegate?
    weak var dataSource: CarouselViewDataSource?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    var showsIndicatorDots: Bool = true

    var numItems: Int = 0 {
        didSet {
            pageControl.numberOfPages = numItems
        }
    }
    let bufferSectionsPerSide = 1

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

    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }

    func reloadData() {
        numItems = dataSource?.numberOfItems(in: self) ?? 0
        collectionView.reloadData()
        reset()
    }

    internal func reset() {
        DispatchQueue.main.async {
            var currentIndex = 0

            if let visibleCell = self.collectionView.visibleCells.first {
                let indexPath = self.collectionView.indexPath(for: visibleCell)!
                currentIndex = indexPath.item
            }

            let index = currentIndex % self.numItems + self.numItems * self.bufferSectionsPerSide
            self.pageControl.currentPage = index % self.numItems
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell(withReuseIdentifier identifier: String, forIndex index: Int) -> UICollectionViewCell {
        let indexPath = IndexPath(item: index, section: 0)
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reset()
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.carouselView?(self, didSelectItemAt: indexPath.item)
    }
}

extension CarouselView: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let bufferSectionsPerSide = 1

        return numItems * bufferSectionsPerSide * 2 + numItems
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let adjustedIndexPathItem = indexPath.row % numItems
        return dataSource!.carouselView(carouselView: self, cellForItemAt: adjustedIndexPathItem)
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




