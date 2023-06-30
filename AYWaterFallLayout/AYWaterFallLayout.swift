//
//  AYWaterFallLayout.swift
//  AYWaterFallLayout
//
//  Created by 王亚威 on 2023/6/28.
//  未解决的问题:1、顶部高度不正确 2、加载更多的处理

import UIKit

protocol AYWaterFallLayoutDataSource: NSObjectProtocol {
    func numberOfCols(layout: AYWaterFallLayout) -> Int
    func waterFallLayout(layout: AYWaterFallLayout, index: Int) -> CGFloat
}

class AYWaterFallLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: AYWaterFallLayoutDataSource?
    
    lazy var attrs = [UICollectionViewLayoutAttributes]()
    lazy var totalHeights = Array(repeating: self.sectionInset.top, count: self.dataSource?.numberOfCols(layout: self) ?? 2)
    
    // MARK: - 准备布局
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let count = collectionView.numberOfItems(inSection: 0)
        let cols = dataSource?.numberOfCols(layout: self) ?? 2
        let w: CGFloat = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1)*minimumInteritemSpacing)/CGFloat(cols)

        //设置每个UICollectionViewLayoutAttributes
        for i in 0..<count {
            //创建indexpath
            let indexPath = IndexPath(row: i, section: 0)
            //创建indexpath对应的attr
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let minH = totalHeights.min()!
            let index = totalHeights.firstIndex(of: minH)!
            //设置attr的frame
            let x: CGFloat = sectionInset.left + CGFloat(index)*(w+minimumInteritemSpacing)
            let y: CGFloat = minH + minimumLineSpacing
            guard let h = dataSource?.waterFallLayout(layout: self, index: index) else {
                fatalError("需要确定index下item的高度")
            }
            attr.frame = CGRect(x: x, y: y, width: w, height: h)
            //保存attr
            attrs.append(attr)
            //添加当前高度
            totalHeights[index] = minH + minimumLineSpacing + h
        }
    }
}


// MARK: - 开始布局
extension AYWaterFallLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
}


// MARK: - 设置ContentSize
extension AYWaterFallLayout {

    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
    
}
