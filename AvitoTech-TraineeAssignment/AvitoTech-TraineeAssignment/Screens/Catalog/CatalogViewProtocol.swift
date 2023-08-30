//
//  CatalogViewProtocol.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 31.08.2023.
//

import UIKit

protocol CatalogViewPresenterProtocol {
    var numberOfAdvertisement: Int { get }
    func injectViewController(viewController: CatalogViewControllerProtocol)
    func viewDidLoad()
    func viewDidPullToRefresh()
    func viewWillConfigureCell(cell: CatalogCell, with indexPath: IndexPath)
    func viewDidTapCell(id: String)
}

protocol CatalogViewControllerProtocol: AnyObject {
    func updateCollection()
    func showAlert(alert: UIAlertController)
    func showHud()
    func removeHud()
    func configureCell(cell: CatalogCell, with model: Advertisement)
    func showCatalogsObjectView(viewController: CatalogsObjectViewController)
}
