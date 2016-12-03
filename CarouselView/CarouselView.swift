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

    var showsIndicatorDots: Bool = true {
        didSet {
           pageControl.isHidden = !showsIndicatorDots
        }
    }

    internal var numItems: Int = 0 {
        didSet {
            pageControl.numberOfPages = numItems
        }
    }

    internal var adjNumItems: Int {
        return paddingItems * 2 + numItems
    }

    internal var paddingItems: Int {
        let paddingSections = 1
        return numItems * paddingSections
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
            let currentIndex = self.indexForCurrentCell()
            let index = self.adjustedIndexWith(currentIndex: currentIndex) + self.paddingItems
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.pageControl.currentPage = self.adjustedIndexWith(currentIndex: currentIndex)
        }
    }

    func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell(withReuseIdentifier identifier: String, forIndex index: Int) -> UICollectionViewCell {
        let indexPath = IndexPath(item: index, section: 0)
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    internal func adjustedIndexWith(currentIndex index: Int) -> Int {
        return index % numItems
    }

    internal func indexForCurrentCell() -> Int {
        var index = 0
        if let visibleCell = self.collectionView.visibleCells.first {
            let indexPath = self.collectionView.indexPath(for: visibleCell)!
            index = indexPath.item
        }
        return index
    }
}

extension CarouselView: UICollectionViewDelegate {
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reset()
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let adjustedIndex = adjustedIndexWith(currentIndex: index)
        delegate?.carouselView?(carouselView: self, didSelectItemAt: adjustedIndex)
    }
}

extension CarouselView: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adjNumItems
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let adjustedIndex = adjustedIndexWith(currentIndex: index)
        return dataSource!.carouselView(carouselView: self, cellForItemAt: adjustedIndex)
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




