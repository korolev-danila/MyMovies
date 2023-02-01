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
        //  label.minimumScaleFactor = 0.5
        label.baselineAdjustment = .alignBaselines
        label.textAlignment  = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let closeBlure: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.clipsToBounds = true
        effect.layer.cornerRadius = 25
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
     let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isEditingClose: Bool = true {
        didSet {
            closeBlure.isHidden = isEditingClose
            closeButton.isHidden = isEditingClose
            closeButton.isEnabled = !isEditingClose
        }
    }
    
    
    func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(filmLogo)
        self.addSubview(filmNameLabel)
        self.addSubview(closeBlure)
        self.addSubview(closeButton)
        isEditingClose = true

        closeButton.addTarget(.none, action: #selector(deletButtonTap), for: .touchDown)
        
        setConstraints()
    }
  
    // MARK: - DeleteButtomTap
    @objc func deletButtonTap() {
        delegate?.delete(cell: self)
    }
    

    func configureMovieCell(movie: MyMovie) {
        if movie.imageData != nil {
            filmLogo.image = UIImage(data: movie.imageData!)
        } else {
            filmLogo.image = nil
        }
        filmNameLabel.text = movie.name
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
}
