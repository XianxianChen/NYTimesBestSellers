//
//  Category.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct CategoryList: Codable {
    let results: [Category]
}
struct Category: Codable {
    let list_name: String
}

struct CategoryAPIClient {
    private init() {}
    static let manager = CategoryAPIClient()
   // let key = "29ca5ca3f7894a91826d750e77fcb227"
    func getCategory(from keyStr: String,
                    completionHandler: @escaping ([Category]) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(keyStr)"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let result = try JSONDecoder().decode(CategoryList.self, from: data)
                let category = result.results
                completionHandler(category)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
        
    }
}
