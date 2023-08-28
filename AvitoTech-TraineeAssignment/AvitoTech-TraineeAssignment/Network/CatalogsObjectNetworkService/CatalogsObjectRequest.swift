//
//  CatalogsObjectRequest.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

struct CatalogsObjectRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Constants.host + "details/\(id).json")
    }
    private var id: String
    
    init(id: String) {
        self.id = id
    }
}
