//
//  CatalogRequest.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    let endpoint: URL? = URL(string: Constants.host + "main-page.json")
}
