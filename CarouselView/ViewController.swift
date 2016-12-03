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

    let colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.purple, UIColor.orange]

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        carouselView.delegate = self
        carouselView.dataSource = self

        let nib = UINib(nibName: "CarouselCell", bundle: nil)
        carouselView.register(nib: nib, forCellWithReuseIdentifier: "CarouselCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: CarouselViewDelegate {
    func carouselView(carouselView: CarouselView, didSelectItemAt index: Int) {
        print("selected item at index \(index)")
    }
}

extension ViewController: CarouselViewDataSource {

    func numberOfItems(in carouselView: CarouselView) -> Int {
        return colors.count
    }

    func carouselView(carouselView: CarouselView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = carouselView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", forIndex: index) as! CarouselCell

        cell.backgroundColor = colors[index]

        return cell
    }
}



