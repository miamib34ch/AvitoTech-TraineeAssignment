//
//  CatalogsObjectViewPresenter.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 31.08.2023.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation

final class CatalogsObjectViewPresenter: CatalogsObjectViewPresenterProtocol {
    var adress: String {
        guard let model = catalogsObjectNetworkService.catalogsObjectModel else { return "" }
        return "г. " + model.location + ", " + model.address
    }

    weak private var viewController: CatalogsObjectViewControllerProtocol?

    private var objectId: String?
    private var email: String?
    private var phoneNumber: String?

    private let catalogsObjectNetworkService = CatalogsObjectNetworkService.shared
    private var catalogsObjectNetworkServiceObserverData: NSObjectProtocol?
    private var catalogsObjectNetworkServiceObserverError: NSObjectProtocol?

    init(objectId: String) {
        self.objectId = objectId
    }

    func injectViewController(viewController: CatalogsObjectViewControllerProtocol) {
        self.viewController = viewController
    }

    func viewDidLoad() {
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
                self?.showViewAlert()
            }
        loadData()
    }

    func viewDidTapMailButton() {
        guard let email = email else { return }
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = viewController as? CatalogsObjectViewController
            mailComposer.setToRecipients([email])
            viewController?.showMailComposer(mailComposer: mailComposer)
        } else {
            // На симуляторе этот вариант будет срабатывать
            print("Почтовый клиент недоступен")
        }
    }

    func viewDidTapCallButton() {
        guard let phoneNumber = phoneNumber else { return }
        if let phoneURL = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                viewController?.showCallAction(phoneURL: phoneURL)
            } else {
                // На симуляторе этот вариант будет срабатывать
                print("Невозможно совершить звонок")
            }
        }
    }

    private func loadData() {
        guard let objectId = objectId else { return }
        viewController?.showHud()
        catalogsObjectNetworkService.fetch(id: objectId)
    }

    private func configureView() {
        guard let model = catalogsObjectNetworkService.catalogsObjectModel else { showViewAlert(); return }
        viewController?.removeHud()
        viewController?.configureView(model: model)
        email = model.email
        phoneNumber = model.phoneNumber
        geocodeCity(cityName: adress)
    }

    private func showViewAlert() {
        viewController?.removeHud()
        let alertTitle = NSLocalizedString("alert.title", comment: "Название алерта")
        let alertMessage = NSLocalizedString("alert.message", comment: "Сообщение в алерте")
        let alertActionRetryTitle = NSLocalizedString("alert.action.again", comment: "Название действия повторения в алерте")
        let alertActionLeaveTitle = NSLocalizedString("alert.action.leave", comment: "Название действия выхода в алерте")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionRetry = UIAlertAction(title: alertActionRetryTitle, style: .default) { [weak self] _ in
            self?.loadData()
        }
        let actionLeave = UIAlertAction(title: alertActionLeaveTitle, style: .default) { [weak self] _ in
            alert.dismiss(animated: true)
            self?.viewController?.backButtonTap()
        }
        alert.addAction(actionRetry)
        alert.addAction(actionLeave)
        viewController?.showAlert(alert: alert)
    }

    private func geocodeCity(cityName: String) {
        guard !cityName.isEmpty else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let error = error {
                print("Координаты не найдены: \(error.localizedDescription)")
                self.geocodeCity(cityName: cityName.split(separator: ",").first?.description ?? "" )
                return
            }

            if let location = placemarks?.first?.location?.coordinate {
                self.setupMapWithCoordinate(coordinate: location, title: cityName)
            } else {
                print("Координаты не найдены.")
            }
        }
    }

    private func setupMapWithCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        viewController?.setupMap(annotation: annotation, region: region)
    }
}
