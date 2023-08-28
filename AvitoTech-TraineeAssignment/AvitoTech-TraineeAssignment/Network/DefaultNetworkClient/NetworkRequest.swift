//
//  NetworkRequest.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: String { get }
}

// Значение по-умолчанию
extension NetworkRequest {
    var httpMethod: String { "GET" }
}
