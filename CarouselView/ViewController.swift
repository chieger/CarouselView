//
//  ViewController.swift
//  CarouselView
//
//  Created by Charles Hieger on 11/30/16.
//  Copyright © 2016 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var carouselView: CarouselView!

    let colors = [UIColor.red, UIColor.green, UIColor.blue]

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        carouselView.delegate = self
        carouselView.dataSource = self

        let nib = UINib(nibName: "CarouselCell", bundle: nil)
        carouselView.collectionView.register(nib, forCellWithReuseIdentifier: "CarouselCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
extension ViewController: CarouselViewDelegate {

}

extension ViewController: CarouselViewDataSource {
    func carouselView(_ carouselView: CarouselView, numberOfItems items: Int) -> Int {
        return colors.count

    }

    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselView.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}



