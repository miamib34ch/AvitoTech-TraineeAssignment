//
//  CatalogsObjectViewController.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 30.08.2023.
//

import UIKit
import MapKit

final class CatalogsObjectViewController: UIViewController {
    private var objectId: String?

    private let catalogsObjectNetworkService = CatalogsObjectNetworkService.shared
    private var catalogsObjectNetworkServiceObserverData: NSObjectProtocol?
    private var catalogsObjectNetworkServiceObserverError: NSObjectProtocol?

    init(objectId: String) {
        self.objectId = objectId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        catalogsObjectNetworkServiceObserverData = NotificationCenter.default
            .addObserver(
                forName: CatalogsObjectNetworkService.dataReceivedNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.configureView()
            }
        catalogsObjectNetworkServiceObserverError = NotificationCenter.default
            .addObserver(
                forName: CatalogsObjectNetworkService.errorNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.showAlert()
            }
        loadData()
    }

    private func configureView() {
        UIBlockingProgressHUD.dismiss()
    }

    private func showAlert() {
        UIBlockingProgressHUD.dismiss()
        let alertTitle = NSLocalizedString("alert.title", comment: "Название алерта")
        let alertMessage = NSLocalizedString("alert.message", comment: "Сообщение в алерте")
        let alertActionRetryTitle = NSLocalizedString("alert.action.again", comment: "Название действия повторения в алерте")
        let alertActionLeaveTitle = NSLocalizedString("alert.action.leave", comment: "Название действия выхода в алерте")

        let actionRetry = UIAlertAction(title: alertActionRetryTitle, style: .default) { [weak self] _ in
            self?.loadData()
        }
        let actionLeave = UIAlertAction(title: alertActionLeaveTitle, style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(actionRetry)
        alert.addAction(actionLeave)
        present(alert, animated: true)
    }

    private func loadData() {
        guard let objectId = objectId else { return }
        UIBlockingProgressHUD.show()
        catalogsObjectNetworkService.fetch(id: objectId)
    }
}
