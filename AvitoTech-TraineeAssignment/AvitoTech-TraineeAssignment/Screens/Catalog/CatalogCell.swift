//
//  CatalogCell.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 29.08.2023.
//

import UIKit
import Kingfisher

final class CatalogCell: UICollectionViewCell, ReuseIdentifying {
    var id: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
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
        label.numberOfLines = 2
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
    private let adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        imageView.image = nil
        nameLabel.text = ""
        costLabel.text = ""
        adressLabel.text = ""
        dateLabel.text = ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(link: URL?) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: link)
    }

    func setNameLabel(name: String) {
        nameLabel.text = name
    }

    func setCostLabel(cost: String) {
        costLabel.text = cost
    }

    func adressLabel(adress: String) {
        adressLabel.text = adress
    }

    func dateLabel(date: String) {
        dateLabel.text = date.formattedDate
    }

    private func setView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(costLabel)
        labelsStack.addArrangedSubview(adressLabel)
        labelsStack.addArrangedSubview(dateLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height*0.6),

            labelsStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelsStack.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            labelsStack.heightAnchor.constraint(equalToConstant: contentView.frame.height*0.4 - 8)
        ])
    }
}
