//
//  BestCellerDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/2/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class BestCellerDetailViewController: UIViewController {

    var bookCover: BookCover?
 
    var book: Book!
    var image: UIImage?
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
       self.titleLabel.text = book.book_details[0].title
       self.authorLabel.text = book.book_details[0].author
       // self.descriptionLabel.text = book.book_details[0].description
        self.imageView.image = self.image
        guard !book.isbns.isEmpty else {return}
         loadBookCover(from: book.isbns[0].isbn10)
       
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        guard self.image != nil else {return}
        PersistantFileClient.manager.addToFavorite(of: book, and: self.imageView.image!)
    }
    func loadBookCover(from isbn: String) {
        let completion: (BookCover) -> Void = {(onlineBookCover: BookCover) in
             self.bookCover = onlineBookCover
            self.descriptionLabel.text = onlineBookCover.volumeInfo?.description ?? "No description"
            self.subtitleLabel.text = self.bookCover?.volumeInfo?.subtitle ?? "No Subtitle"
        }
        BookCoverAPIClient.manager.getBookCover(from: isbn, completionHandler: completion, errorHandler: {print($0)})
        
        
    }

   
    

   

}
