//
//  NewsData.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 04.02.2023.
//

import Foundation

struct NewsData: Decodable {
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
}

struct Source: Decodable{
    let name: String?
}
