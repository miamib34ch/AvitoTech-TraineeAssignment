//
//  CatalogViewController.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 26.08.2023.
//

import UIKit

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    // MARK: - private properties
    private var presenter: CatalogViewPresenterProtocol
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let refreshControl = UIRefreshControl()


    // MARK: - class methods

    init(presenter: CatalogViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureCollection()
        configureRefreshControl()

        presenter.viewDidLoad()
    }


    // MARK: - protocol's methods

    func updateCollection() {
        collectionView.reloadData()
    }

    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }

    func showHud() {
        UIBlockingProgressHUD.show()
    }

    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }

    func configureCell(cell: CatalogCell, with model: Advertisement) {
        cell.id = model.id
        cell.setImage(link: URL(string: model.imageURL))
        cell.setNameLabel(name: model.title)
        cell.setCostLabel(cost: model.price)
        cell.adressLabel(adress: model.location)
        cell.dateLabel(date: model.createdDate)
    }

    func showCatalogsObjectView(viewController: CatalogsObjectViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: - private methods

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


    // MARK: - @objc methods

    @objc private func pullToRefresh() {
        refreshControl.endRefreshing()
        presenter.viewDidPullToRefresh()
    }
}


// MARK: - extension CatalogViewController + UICollectionViewDelegateFlowLayout

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


// MARK: - extension CatalogViewController + UICollectionViewDataSource

extension CatalogViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfAdvertisement
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatalogCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        presenter.viewWillConfigureCell(cell: cell, with: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CatalogCell,
              let id = cell.id else { return }
        presenter.viewDidTapCell(id: id)
    }
}
