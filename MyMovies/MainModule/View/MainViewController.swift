//
//  MainViewController.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadData()
}

final class MainViewController: UIViewController {
    private let presenter: MainPresenterProtocol
    
    private var didSelectItemAtIsEnabled = true
    
    private var myCollectionView: UICollectionView = {
        let collection = UICollectionView()
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collection.backgroundColor = .black
        return collection
    }()
    
    // MARK: - Initialize Method
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.fetchMovies()
    }
    
    // MARK: - Private Method
    private func setupView() {
        view.backgroundColor = .black
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 130)
        
        myCollectionView.frame = view.frame
        myCollectionView.setCollectionViewLayout(layout, animated: false)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        view.addSubview(myCollectionView)
        settingNC()
    }
    
    private func settingNC() {
        navigationController?.navigationBar.backgroundColor = .blue
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setAdd))
        addButton.tintColor = .white
        navigationController?.navigationBar.topItem?.setRightBarButton(addButton, animated: true)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setEdit))
        editButton.tintColor = .white
        navigationController?.navigationBar.topItem?.setLeftBarButton(editButton, animated: true)
    }
    
    private func changeCellButton(isHidden: Bool) {
        didSelectItemAtIsEnabled = isHidden
        let indexPaths = myCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            if let cell = myCollectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.isEditingClose = isHidden
            }
        }
    }
    
    // MARK: - Action
    @objc func setAdd() {
        self.presenter.showSearch()
    }
    
    @objc func setDone() {
        settingNC()
        changeCellButton(isHidden: true)
    }
    
    @objc func setEdit() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(setDone))
        doneButton.tintColor = .white
        navigationItem.setLeftBarButton(doneButton, animated: true)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setAdd))
        addButton.isEnabled = false
        navigationItem.setRightBarButton(addButton, animated: true)
        
        changeCellButton(isHidden: false)
    }
}

// MARK: - Collection DataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemAtIsEnabled {
            presenter.showDetail(index: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getCountMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        myCell.configureMovieCell(cellModel: presenter.getCellModel(index: indexPath))
        myCell.delegate = self
        return myCell
    }
}

// MARK: - CollectionViewCellDelegate
extension MainViewController: CollectionViewCellDelegate {
    func delete(cell: CollectionViewCell) {
        if let indexPath = myCollectionView.indexPath(for: cell) {
            presenter.delete(index: indexPath)
            myCollectionView.deleteItems(at: [indexPath])
            presenter.fetchMovies()
        }
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func reloadData() {
        myCollectionView.reloadData()
    }
}
