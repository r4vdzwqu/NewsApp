//
//  HeadlinesCell.swift
//

import UIKit
import Kingfisher

class HeadlinesCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsSourcesCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.articleImageView.image = nil
        self.titleLabel.text = nil
    }
    
    func configureLayout() {
        backgroundColor = .white
//        contentView.addSubview(mainStackView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(articleImageView)
        
//        mainStackView.addArrangedSubview(titleLabel)
//        mainStackView.addArrangedSubview(articleImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 90),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension HeadlinesCell {
    func configure(title: String, imageLink: String) {
        self.titleLabel.text = title
        guard let imageURL = URL(string: imageLink) else { return }
        self.articleImageView.kf.setImage(with: imageURL)
    }
}
