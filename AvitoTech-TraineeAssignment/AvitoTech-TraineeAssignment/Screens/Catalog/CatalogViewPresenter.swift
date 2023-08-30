//
//  CatalogViewPresenter.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 31.08.2023.
//

import UIKit

final class CatalogViewPresenter: CatalogViewPresenterProtocol {
    var numberOfAdvertisement: Int {
        catalogNetworkService.catalogModel?.advertisements.count ?? 0
    }

    weak private var viewController: CatalogViewControllerProtocol?
    private let catalogNetworkService = CatalogNetworkService.shared
    private var catalogNetworkServiceObserverData: NSObjectProtocol?
    private var catalogNetworkServiceObserverError: NSObjectProtocol?

    func injectViewController(viewController: CatalogViewControllerProtocol) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        catalogNetworkServiceObserverData = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.dataReceivedNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateViewCollection()
            }
        catalogNetworkServiceObserverError = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.errorNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.showViewAlert()
            }
        loadData()
    }

    func viewDidPullToRefresh() {
        loadData()
    }

    func viewWillConfigureCell(cell: CatalogCell, with indexPath: IndexPath) {
        guard let model = catalogNetworkService.catalogModel?.advertisements[indexPath.row] else { return }
        viewController?.configureCell(cell: cell, with: model)
    }

    private func updateViewCollection() {
        viewController?.removeHud()
        viewController?.updateCollection()
    }

    private func showViewAlert() {
        viewController?.removeHud()
        let alertTitle = NSLocalizedString("alert.title", comment: "Название алерта")
        let alertMessage = NSLocalizedString("alert.message", comment: "Сообщение в алерте")
        let alertActionTitle = NSLocalizedString("alert.action.again", comment: "Название действия повторения в алерте")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertActionTitle, style: .default) { [weak self] _ in
            self?.loadData()
        })
        viewController?.showAlert(alert: alert)
    }

    private func loadData() {
        viewController?.showHud()
        catalogNetworkService.fetch()
    }
}
