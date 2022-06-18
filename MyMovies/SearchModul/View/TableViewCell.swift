//
//  TableViewCell.swift
//  MyMovies
//
//  Created by Данила on 16.05.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    private let filmLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let filmNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name film"
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.2
        label.baselineAdjustment = .alignBaselines
        label.textAlignment  = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearsLabel: UILabel = {
       let label = UILabel()
        label.text = "2016 year"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(filmLogo)
        self.addSubview(filmNameLabel)
        self.addSubview(yearsLabel)

    }
    
    func setImage(imageData: Data) {
        if imageData != nil {
            let image = UIImage(data: imageData)
            filmLogo.image = image
        } else {
            filmLogo.image = nil
        }
    }
    
    func configureFilmCell(film: Film) {
    filmNameLabel.text = film.name
    yearsLabel.text = "\(film.year) year"
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            filmLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filmLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            filmLogo.heightAnchor.constraint(equalToConstant: 124),
            filmLogo.widthAnchor.constraint(equalToConstant: 94)
        ])
        
        NSLayoutConstraint.activate([
            filmNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            filmNameLabel.leadingAnchor.constraint(equalTo: filmLogo.trailingAnchor, constant: 10),
            filmNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            yearsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            yearsLabel.leadingAnchor.constraint(equalTo: filmLogo.trailingAnchor, constant: 10),
            yearsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
