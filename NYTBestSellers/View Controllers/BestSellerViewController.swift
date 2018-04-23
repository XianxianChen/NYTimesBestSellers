//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    let cellSpacing: CGFloat = 10.0
    let key = "29ca5ca3f7894a91826d750e77fcb227"
    var category = [Category]() {
        didSet {
            self.pickerView.reloadAllComponents()
            if let defaultRow = UserDefaults.standard.value(forKey: "default category") as? Int {
                self.pickerView.selectRow(defaultRow, inComponent: 0, animated: true)
                self.pickerView.reloadComponent(0)
                self.selectedCategory = category[defaultRow].list_name
          }
            
        }
    }
    var selectedCategory: String? {
        didSet{
           let categoryStr = selectedCategory!.replacingOccurrences(of: " ", with: "-")
            print(selectedCategory!)
            print(categoryStr)
            loadBooks(from: categoryStr)
        }
    }
    var books = [Book]() {
      didSet {
            self.collectionView.reloadData()
        }
}
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.label.text = "Best Sellers"
        loadCategory()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       loadCategory()
    }
    
    func loadCategory() {
       CategoryAPIClient.manager.getCategory(from: key, completionHandler: {self.category = $0 }, errorHandler: {print($0)})
    }
    func loadBooks(from categoryStr: String) {
        BookAPIClient.manager.getBook(from: categoryStr, completionHandler: {self.books = $0}, errorHandler: {print($0)})
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BestCellerDetailViewController
        let cell = sender as! BookCollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            destination.book = books[indexPath.row]
            destination.image = cell.imageView.image
        }
    }


}
extension BestSellerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row].list_name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = category[row].list_name
    }
}
extension BestSellerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "book cell", for: indexPath) as! BookCollectionViewCell
        cell.configureCell(from: books[indexPath.row])
        
        cell.imageView.image = nil
        guard !books[indexPath.row].isbns.isEmpty else {
            cell.imageView.image = #imageLiteral(resourceName: "noImageFound")
            return cell}
       let isbn = books[indexPath.row].isbns.first?.isbn10
        
        let completion: (BookCover) -> Void = {(onlineBookCover: BookCover) in
           
            ImageAPIClient.manager.getImages(from: onlineBookCover.volumeInfo!.imageLinks.smallThumbnail , completionHandler: {
                cell.imageView.image = $0
                cell.layoutIfNeeded()
                
            }, errorHandler: {print($0)})
        }
        BookCoverAPIClient.manager.getBookCover(from: isbn!, completionHandler: completion, errorHandler: {print($0)})
        
     
        
        return cell
    }
   
}


extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCell: CGFloat = 1
        let numSpacing: CGFloat = numCell + 2
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (numSpacing * cellSpacing)) / numCell, height: screenHeight * 0.45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0) // EdgeInset is top, left, bottom, right spacing of cell to the section edge.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


