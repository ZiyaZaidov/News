//
//  NewsTableViewCellViewModel.swift
//  News
//
//  Created by Ziya Zaidov on 11.12.2023.
//

import Foundation

class NewsTableViewCellViewModel {
    
    let title : String
    let subtitle: String
    let mageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, mageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.mageURL = mageURL
    }
}
