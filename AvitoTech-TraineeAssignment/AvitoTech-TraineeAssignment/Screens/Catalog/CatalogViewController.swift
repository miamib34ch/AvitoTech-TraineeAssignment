//
//  CatalogViewController.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 26.08.2023.
//

import UIKit

class CatalogViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let refreshControl = UIRefreshControl()

    private let catalogNetworkService = CatalogNetworkService.shared
    private var catalogNetworkServiceObserverData: NSObjectProtocol?
    private var catalogNetworkServiceObserverError: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureCollection()
        configureRefreshControl()

        catalogNetworkServiceObserverData = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.dataReceivedNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateCollection()
            }
        catalogNetworkServiceObserverError = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.errorNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.showAlert()
            }
        loadData()
    }

    private func configureCollection() {
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CatalogCell.self)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureRefreshControl() {
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    private func updateCollection() {
        UIBlockingProgressHUD.dismiss()
        collectionView.reloadData()
    }

    private func showAlert() {
        UIBlockingProgressHUD.dismiss()
        let alertTitle = NSLocalizedString("alert.title", comment: "Название алерта")
        let alertMessage = NSLocalizedString("alert.message", comment: "Сообщение в алерте")
        let alertActionTitle = NSLocalizedString("alert.action.again", comment: "Название действия повторения в алерте")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertActionTitle, style: .default) { [weak self] _ in
            self?.loadData()
        })
        present(alert, animated: true)
    }

    private func loadData() {
        UIBlockingProgressHUD.show()
        catalogNetworkService.fetch()
    }

    @objc func pullToRefresh() {
        refreshControl.endRefreshing()
        loadData()
    }
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 2 - 10  // MARK: из ширины экрана вычитаем констрейнты (16+16=32) и получаем ширину коллекции, делим её на 2, так как по 2 ячейки, а также вычитаем расстояние между ячейками (10)
        let height = width / 0.6
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catalogNetworkService.catalogModel?.advertisements.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatalogCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let model = catalogNetworkService.catalogModel?.advertisements[indexPath.row] else { return cell }
        cell.id = model.id
        cell.setImage(link: URL(string: model.imageURL))
        cell.setNameLabel(name: model.title)
        cell.setCostLabel(cost: model.price)
        cell.adressLabel(adress: model.location)
        cell.dateLabel(date: model.createdDate)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CatalogCell,
              let id = cell.id else { return }
        navigationController?.pushViewController(CatalogsObjectViewController(objectId: id), animated: true)
    }
}
