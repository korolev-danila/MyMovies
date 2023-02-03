//
//  DetailViewController.swift
//  MyMovies
//
//  Created by Данила on 17.05.2022.
//

import UIKit
import Cosmos

protocol DetailViewProtocol: AnyObject {
    func setMovie(_ model: ViewModel)
}

final class DetailViewController: UIViewController {
    private let presenter: DetailPresenterProtocol
    
    private let filmLogo: UIImageView = {
        let imageView = UIImageView()
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
        label.textAlignment  = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let watchedSwith: UISwitch = {
        let swith = UISwitch()
        swith.translatesAutoresizingMaskIntoConstraints = false
        return swith
    }()
    
    private let watchedLabel: UILabel = {
        let label = UILabel()
        label.text = "Watched"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 15
        textView.backgroundColor = .gray.withAlphaComponent(0.1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let cosmosRatingView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        cosmosView.settings.starSize = 32
        return cosmosView
    }()
    
    // MARK: - Initialize Method
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        settingNC()
        watchedSwith.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // self.hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        presenter.getMovie()
    }
    
    // MARK: - Private method
    private func settingNC() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain , target: self, action: #selector(saveButton))
        saveButton.tintColor = .white
        self.navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    private func setConstraints() {
        view.addSubview(filmLogo)
        view.addSubview(filmNameLabel)
        view.addSubview(yearsLabel)
        view.addSubview(watchedSwith)
        view.addSubview(watchedLabel)
        view.addSubview(commentTextView)
        view.addSubview(cosmosRatingView)
        
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        NSLayoutConstraint.activate([
            filmLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filmLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: (navBarHeight ?? 0) + 24),
            filmLogo.heightAnchor.constraint(equalToConstant: 164),
            filmLogo.widthAnchor.constraint(equalToConstant: 164)
        ])
        
        NSLayoutConstraint.activate([
            filmNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filmNameLabel.topAnchor.constraint(equalTo: filmLogo.bottomAnchor, constant: 16),
            filmNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            filmNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            yearsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            yearsLabel.bottomAnchor.constraint(equalTo: filmNameLabel.bottomAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            watchedLabel.bottomAnchor.constraint(equalTo: filmNameLabel.bottomAnchor, constant: 36),
            watchedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            watchedSwith.topAnchor.constraint(equalTo: watchedLabel.bottomAnchor, constant: 4),
            watchedSwith.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: watchedSwith.bottomAnchor, constant: 16),
            commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            commentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            cosmosRatingView.topAnchor.constraint(equalTo: yearsLabel.bottomAnchor, constant: 4),
            cosmosRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            cosmosRatingView.bottomAnchor.constraint(equalTo: commentTextView.topAnchor, constant: -4)
        ])
    }
    
    // MARK: - Keyboard notification
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - target
    @objc func saveButton() {        
        presenter.tapSave(watched: watchedSwith.isOn,
                          comment: commentTextView.text,
                          rating: cosmosRatingView.rating)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        if sender.isOn {
            cosmosRatingView.isHidden = false
        } else {
            cosmosRatingView.isHidden = true
        }
    }
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func setMovie(_ model: ViewModel) {
        watchedSwith.isOn = model.watched
        filmNameLabel.text = model.name
        cosmosRatingView.rating = model.rating
        yearsLabel.text = model.year
        commentTextView.text = model.comment
        
        if model.watched != true {
            cosmosRatingView.isHidden = true
        }
        
        if let img = model.imageData {
            filmLogo.image = UIImage(data: img)
        }
    }
}
