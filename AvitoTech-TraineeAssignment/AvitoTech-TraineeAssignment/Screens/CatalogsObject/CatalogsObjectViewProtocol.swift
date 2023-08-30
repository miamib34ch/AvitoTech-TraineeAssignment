//
//  CatalogsObjectViewProtocol.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 31.08.2023.
//

import UIKit
import MapKit
import MessageUI

protocol CatalogsObjectViewPresenterProtocol {
    var adress: String { get }
    func injectViewController(viewController: CatalogsObjectViewControllerProtocol)
    func viewDidLoad()
    func viewDidTapMailButton()
    func viewDidTapCallButton()
}

protocol CatalogsObjectViewControllerProtocol: AnyObject {
    func showHud()
    func removeHud()
    func configureView(model: CatalogsObjectModel)
    func showAlert(alert: UIAlertController)
    func backButtonTap()
    func showMailComposer(mailComposer: MFMailComposeViewController)
    func showCallAction(phoneURL: URL)
    func setupMap(annotation: MKPointAnnotation, region: MKCoordinateRegion)
}
