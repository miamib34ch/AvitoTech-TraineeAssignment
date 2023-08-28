//
//  CatalogsObjectNetworkService.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 28.08.2023.
//

import Foundation

protocol CatalogsObjectNetworkServiceProtocol {
    static var shared: CatalogsObjectNetworkServiceProtocol { get }
    static var dataReceivedNotification: NSNotification.Name { get }
    static var errorNotification: NSNotification.Name { get }
    
    var catalogsObjectModel: CatalogsObjectModel? { get }
    var error: Error? { get }
    
    func fetch(id: String)
}

final class CatalogsObjectNetworkService: CatalogsObjectNetworkServiceProtocol {
    static var shared: CatalogsObjectNetworkServiceProtocol = CatalogsObjectNetworkService()
    static let dataReceivedNotification = Notification.Name(rawValue: "CatalogsObjectNetworkServiceDidReceiveData")
    static let errorNotification = Notification.Name(rawValue: "CatalogsObjectNetworkServiceError")
    
    private(set) var catalogsObjectModel: CatalogsObjectModel?
    private(set) var error: Error?
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var task: NetworkTask?
    
    private init() {}
    
    func fetch(id: String) {
        assert(Thread.isMainThread)
        
        if task != nil {
            return
        }
        
        let request = CatalogsObjectRequest(id: id)
        
        let task = defaultNetworkClient.send(request: request, type: CatalogsObjectModel.self, onResponse: resultHandler)
        
        self.task = task
    }
    
    private func resultHandler(_ res: Result<CatalogsObjectModel, Error>) {
        task = nil
        switch res {
        case .success(let catalogsObjectModel):
            self.catalogsObjectModel = catalogsObjectModel
            NotificationCenter.default.post(name: CatalogsObjectNetworkService.dataReceivedNotification, object: self)
        case .failure(let error):
            self.error = error
            NotificationCenter.default.post(name: CatalogsObjectNetworkService.errorNotification, object: self)
        }
    }
}
