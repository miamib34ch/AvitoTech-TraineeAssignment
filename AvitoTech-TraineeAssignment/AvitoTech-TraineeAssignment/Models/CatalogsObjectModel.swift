//
//  CatalogsObjectModel.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

struct CatalogsObjectModel: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageURL: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, location, description, email, address
        case imageURL = "image_url"
        case createdDate = "created_date"
        case phoneNumber = "phone_number"
    }
}

/*
Пример:
{
"id": "1",
"title": "Смартфон Apple iPhone 12",
"price": "55000 ₽",
"location": "Москва",
"image_url": "https://www.avito.st/s/interns-ios/images/1.png",
"created_date": "2023-08-16",
"description": "Отличное состояние, последняя модель iPhone.",
"email": "example1@example.com",
"phone_number": "+7 (123) 456-7890",
"address": "ул. Пушкина, д. 1"
}
*/
