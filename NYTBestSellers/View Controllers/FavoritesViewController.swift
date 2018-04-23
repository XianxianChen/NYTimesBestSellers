//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/2/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let cellSpacing: CGFloat = 20.0
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favorite cell", for: indexPath) as! FavoriteCollectionViewCell
        let str = PersistantFileClient.manager.getFavorite()[indexPath.row].book_details[0].title
        let imageURL = PersistantFileClient.manager.dataFilePath(with: str)
        cell.imageView.image = UIImage(contentsOfFile: imageURL.path)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PersistantFileClient.manager.favorites.count
    }
 
    

    

}
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCell: CGFloat = 2
        let numSpacing: CGFloat = numCell + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (numSpacing * cellSpacing)) / numCell, height: screenHeight * 0.3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing , left: cellSpacing, bottom: cellSpacing, right: cellSpacing) // EdgeInset is top, left, bottom, right spacing of cell to the section edge.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


