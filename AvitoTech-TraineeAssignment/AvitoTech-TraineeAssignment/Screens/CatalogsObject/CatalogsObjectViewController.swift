//
//  CatalogsObjectViewController.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 30.08.2023.
//

import UIKit
import MapKit
import MessageUI

final class CatalogsObjectViewController: UIViewController, CatalogsObjectViewControllerProtocol {
    private var presenter: CatalogsObjectViewPresenterProtocol


    // MARK: - ui properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.distribution = .fillProportionally
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyRegular
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.caption1
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        let title = NSLocalizedString("call", comment: "Название на кнопке вызова")
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(callButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var mailButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.caption1
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        let title = NSLocalizedString("mail", comment: "Название на кнопке написать")
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(mailButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()


    // MARK: - class methods

    init(presenter: CatalogsObjectViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationBar()

        presenter.viewDidLoad()
    }


    // MARK: - protocol's methods

    func showHud() {
        UIBlockingProgressHUD.show()
    }

    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }

    func configureView(model: CatalogsObjectModel) {
        configureConstraints()
        configureImage(link: URL(string: model.imageURL))
        configureLabels(
            name: model.title,
            cost: model.price,
            date: model.createdDate,
            description: model.description,
            adress: presenter.adress)
    }

    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }

    func showMailComposer(mailComposer: MFMailComposeViewController) {
        present(mailComposer, animated: true, completion: nil)
    }

    func showCallAction(phoneURL: URL) {
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    }

    func setupMap(annotation: MKPointAnnotation, region: MKCoordinateRegion) {
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }


    // MARK: - private methods

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .backArrow, style: .plain, target: self, action: #selector(backButtonTap))
    }

    private func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        scrollView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(costLabel)
        labelsStack.addArrangedSubview(dateLabel)
        labelsStack.addArrangedSubview(descriptionLabel)

        scrollView.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(callButton)
        buttonsStack.addArrangedSubview(mailButton)

        scrollView.addSubview(adressLabel)
        scrollView.addSubview(mapView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width),

            labelsStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            labelsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            labelsStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            buttonsStack.topAnchor.constraint(equalTo: labelsStack.bottomAnchor, constant: 20),
            buttonsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonsStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50),

            adressLabel.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 20),
            adressLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            adressLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            adressLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            mapView.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }

    private func configureImage(link: URL?) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: link)
    }

    private func configureLabels(name: String, cost: String, date: String, description: String, adress: String) {
        nameLabel.text = name
        costLabel.text = cost
        dateLabel.text = date.formattedDate
        descriptionLabel.text = description
        adressLabel.text = adress
    }


    // MARK: - @objc methods

    @objc func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func callButtonTap() {
        presenter.viewDidTapCallButton()
    }

    @objc private func mailButtonTap() {
        presenter.viewDidTapMailButton()
    }
}


// MARK: - extension CatalogsObjectViewController + MFMailComposeViewControllerDelegate

extension CatalogsObjectViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
