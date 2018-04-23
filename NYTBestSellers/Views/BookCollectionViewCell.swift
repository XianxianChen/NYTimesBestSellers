//
//  BookCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
   func configureCell(from book: Book) {
    self.numberLabel.text = "\(book.weeks_on_list) weeks on the best sellers list"
    self.shortDescriptionLabel.text = book.book_details[0].description
    }
}
