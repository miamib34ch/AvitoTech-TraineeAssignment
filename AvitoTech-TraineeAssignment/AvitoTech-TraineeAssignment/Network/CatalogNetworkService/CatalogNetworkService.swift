//
//  CatalogNetworkService.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

protocol CatalogNetworkServiceProtocol {
    static var shared: CatalogNetworkServiceProtocol { get }
    static var dataReceivedNotification: NSNotification.Name { get }
    static var errorNotification: NSNotification.Name { get }
    
    var catalogModel: CatalogModel? { get }
    
    func fetch()
}

final class CatalogNetworkService: CatalogNetworkServiceProtocol {
    static var shared: CatalogNetworkServiceProtocol = CatalogNetworkService()
    static let dataReceivedNotification = Notification.Name(rawValue: "CatalogNetworkServiceDidReceiveData")
    static let errorNotification = Notification.Name(rawValue: "CatalogNetworkServiceError")
    
    private(set) var catalogModel: CatalogModel?
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?
    
    private init() {}
    
    func fetch() {
        assert(Thread.isMainThread)
        
        if task != nil {
            return
        }
        
        let request = CatalogRequest()
        
        let task = defaultNetworkClient.send(request: request, type: CatalogModel.self, onResponse: resultHandler)
        
        self.task = task
    }
    
    private func resultHandler(_ res: Result<CatalogModel, Error>) {
        task = nil
        switch res {
        case .success(let catalogModel):
            self.catalogModel = catalogModel
            NotificationCenter.default.post(name: CatalogNetworkService.dataReceivedNotification, object: self)
        case .failure(let error):
            print(error)
            NotificationCenter.default.post(name: CatalogNetworkService.errorNotification, object: self)
        }
    }
}
