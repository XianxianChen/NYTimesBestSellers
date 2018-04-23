//
//  BookImage.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//
// book's long description & cover image
import Foundation
struct BookCoverInfo: Codable {
    let items: [BookCover]?
}
struct BookCover: Codable {
    let volumeInfo: volumeInfoList?
}
struct volumeInfoList: Codable {
    let subtitle: String?
    let description: String?
    let averageRating: Double?
    let ratingsCount: Int?
    let imageLinks: ImageLinkList
    
}
struct ImageLinkList: Codable {
    let smallThumbnail: URL
    let thumbnail: URL
}

struct BookCoverAPIClient {
    private init() {}
    static let manager = BookCoverAPIClient()
    let key = "AIzaSyBjnQ9bm1cmWRm1QbU_nyhaUMm2clNL6q0"
    func getBookCover(from isbn: String,
                    completionHandler: @escaping (BookCover) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://www.googleapis.com/books/v1/volumes?api-key=\(key)&q=+isbn:\(isbn)"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let result = try JSONDecoder().decode(BookCoverInfo.self, from: data)
                if let bookCover = result.items?.first {
                completionHandler(bookCover)
                } else {errorHandler(AppError.noData)}
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
