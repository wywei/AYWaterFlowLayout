//
//  ViewController.swift
//  AYWaterFallLayout
//
//  Created by 王亚威 on 2023/6/28.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = AYWaterFallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.dataSource = self
                
        let v = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        v.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "reuse")
        v.dataSource = self
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath)
        cell.backgroundColor = UIColor.purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
}

extension ViewController: AYWaterFallLayoutDataSource {
    func numberOfCols(layout: AYWaterFallLayout) -> Int {
        return 4
    }
    
    func waterFallLayout(layout: AYWaterFallLayout, index: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 100)
    }
}
