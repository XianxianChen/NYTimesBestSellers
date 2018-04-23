//
//  Book.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct BookList: Codable {
    let results: [Book]
}
struct Book: Codable {
    let rank_last_week: Int
    let weeks_on_list: Int
    let isbns: [IsbnsList]
    let book_details: [BookDetailsInfo]
}
struct IsbnsList: Codable {
    let isbn10: String // isbns[0]
   // let isbn13: String
    
}
struct BookDetailsInfo: Codable {
    let title: String
    let description: String
    let author: String
    let primary_isbn10: String
}
struct BookAPIClient {
    private init() {}
    static let manager = BookAPIClient()
    let key = "29ca5ca3f7894a91826d750e77fcb227"
    func getBook(from categoryStr: String,
                    completionHandler: @escaping ([Book]) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(key)&list=\(categoryStr)"
       
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let result = try JSONDecoder().decode(BookList.self, from: data)
                let books = result.results
                completionHandler(books)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
/*
{
    "status": "OK",
    "copyright": "Copyright (c) 2017 The New York Times Company.  All Rights Reserved.",
    "num_results": 15,
    "last_modified": "2017-12-15T14:38:02-05:00",
    "results": [
    {
    "list_name": "Hardcover Fiction",
    "display_name": "Hardcover Fiction",
    "bestsellers_date": "2017-12-09",
    "published_date": "2017-12-24",
    "rank": 1,
    "rank_last_week": 2,
    "weeks_on_list": 10,
    "asterisk": 0,
    "dagger": 0,
    "amazon_product_url": "https://www.amazon.com/Origin-Novel-Dan-Brown-ebook/dp/B01LY7FD0D?tag=NYTBS-20",
    "isbns": [
    {
    "isbn10": "0385514239",
    "isbn13": "9780385514231"
    },
    {
    "isbn10": "0385542690",
    "isbn13": "9780385542692"
    },
    {
    "isbn10": "0525434305",
    "isbn13": "9780525434306"
    }
    ],
    "book_details": [
    {
    "title": "ORIGIN",
    "description": "A symbology professor goes on a perilous quest with a beautiful museum director.",
    "contributor": "by Dan Brown",
    "author": "Dan Brown",
    "contributor_note": "",
    "price": 0,
    "age_group": "",
    "publisher": "Doubleday",
    "primary_isbn13": "9780385514231",
    "primary_isbn10": "0385514239"
    }
    ],
    "reviews": [
    {
    "book_review_link": "",
    "first_chapter_link": "",
    "sunday_review_link": "",
    "article_chapter_link": ""
    }
    ]
    },
*/
