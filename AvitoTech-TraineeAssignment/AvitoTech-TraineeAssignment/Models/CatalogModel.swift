//
//  CatalogModel.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

struct CatalogModel: Codable {
    let advertisements: [Advertisement]
}

struct Advertisement: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageURL: String
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}

/*
 Пример:
 {
    "advertisements": [
        {
            "id": "1",
            "title": "Смартфон Apple iPhone 12",
            "price": "55000 ₽",
            "location": "Москва",
            "image_url": "https://www.avito.st/s/interns-ios/images/1.png",
            "created_date": "2023-08-16"
        },
        {
            "id": "2",
            "title": "Ноутбук Dell XPS 15",
            "price": "95000 ₽",
            "location": "Санкт-Петербург",
            "image_url": "https://www.avito.st/s/interns-ios/images/2.png",
            "created_date": "2023-08-15"
        }
    ]
 }
 */
