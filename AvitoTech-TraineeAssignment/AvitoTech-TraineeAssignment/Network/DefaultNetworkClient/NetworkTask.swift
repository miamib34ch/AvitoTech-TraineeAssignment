//
//  NetworkTask.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
