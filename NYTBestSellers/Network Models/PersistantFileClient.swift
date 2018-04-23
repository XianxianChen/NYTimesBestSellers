//
//  PersistantFileClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/2/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import UIKit
class PersistantFileClient {
    private init() {}
    static let manager = PersistantFileClient()
    private let kpathName = "FavoriteBook.plist"
    var favorites = [Book]() {
        didSet {
            saveFavorite()
        }
    }
    
    func documentDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
    }
    
    func dataFilePath(with path: String) -> URL {
     return PersistantFileClient.manager.documentDirectory().appendingPathComponent(path)
     
    }
    func saveFavorite() {
        let encoder = PropertyListEncoder()
        do {
       let data = try encoder.encode(favorites)
          try data.write(to: dataFilePath(with: kpathName))
        } catch {
            print("Encoding error: \(error)")
        }
        print("\n==================================================")
        print(documentDirectory())
        print("===================================================\n")
    }
    func load() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath(with: kpathName))
        self.favorites = try decoder.decode([Book].self, from: data)
        } catch {
            print("Decoding error: \(error)")
        }
    }
    func addToFavorite(of book: Book, and image: UIImage) {
        let indexExist = self.favorites.index(where: {$0.book_details[0].title == book.book_details[0].title})
        if indexExist != nil {return}
        self.favorites.append(book)
        storeImageToDisk(of: book, and: image)
        
        
    }
    func getFavorite() -> [Book] {
        return self.favorites
    }
    func storeImageToDisk(of book: Book, and image: UIImage) {
        //// packing data from image
        let data = UIImagePNGRepresentation(image)
        // writing and saving to documents folder
        
        // 1) save image from favorite photo
        let path = dataFilePath(with: book.book_details[0].title)
        do {
            try data?.write(to: path)
        } catch {
            print("Storing image error: \(error)")
        }
    }
    
    
}
