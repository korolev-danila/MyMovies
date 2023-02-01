//
//  CollectionViewCell.swift
//  MyMovies
//
//  Created by Данила on 11.06.2022.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func delete(cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    var isEditingClose: Bool = true {
        didSet {
            closeBlure.isHidden = isEditingClose
            closeButton.isHidden = isEditingClose
            closeButton.isEnabled = !isEditingClose
        }
    }
    
    private let filmLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let filmNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name film"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 2
        label.baselineAdjustment = .alignBaselines
        label.textAlignment  = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeBlure: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.clipsToBounds = true
        effect.layer.cornerRadius = 25
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(filmLogo)
        contentView.addSubview(filmNameLabel)
        contentView.addSubview(closeBlure)
        contentView.addSubview(closeButton)
        
        isEditingClose = true
        closeButton.addTarget(.none, action: #selector(deletButtonTap), for: .touchDown)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmLogo.topAnchor.constraint(equalTo: self.topAnchor),
            filmLogo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            filmLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmLogo.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filmNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            filmNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            filmNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            closeBlure.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            closeBlure.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            closeBlure.widthAnchor.constraint(equalToConstant: 25),
            closeBlure.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    // MARK: - DeleteButtomTap
    @objc func deletButtonTap() {
        delegate?.delete(cell: self)
    }
    
    // MARK: - Public method 
    public func configureMovieCell(cellModel: CellModel) {
        
        if let data = cellModel.imageData{
            filmLogo.image = UIImage(data: data)
        } else {
            filmLogo.image = nil
        }
        
        filmNameLabel.text = cellModel.name
    }
}
