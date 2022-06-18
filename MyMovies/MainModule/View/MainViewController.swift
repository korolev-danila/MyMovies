//
//  MainViewController.swift
//  ViewedMovies
//
//  Created by Данила on 14.05.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var myCollectionView:UICollectionView?
    
    var presenter: MainPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
        
        do {
            presenter.myMyvies = try presenter.context.fetch(fetchRequest)
            print("presenter.myMovies reloaddata")
            myCollectionView?.reloadData()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .black
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 130)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        myCollectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = .black
        
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        
        
        view.addSubview(myCollectionView ?? UICollectionView())
        
        settingNC()
    }
    
    // MARK: - settingNC
    
    func settingNC() {
        print("settingNC")
        self.navigationController?.navigationBar.backgroundColor = .blue
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setAdd))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setEdit))
        addButton.tintColor = .white
        editButton.tintColor = .white
        self.navigationController?.navigationBar.topItem?.setRightBarButton(addButton, animated: true)
        self.navigationController?.navigationBar.topItem?.setLeftBarButton(editButton, animated: true)
    }
    
    @objc func setAdd() {
        self.presenter.showSearch()
    }
    
    
    @objc func setDone() {
        settingNC()
        changeCellButton(isHidden: true)
    }
    
    // MARK: - Delete Items
    var didSelectItemAtIsEnabled: Bool = true
    
    @objc func setEdit() {
        print("setEdit")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(setDone))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setAdd))
        addButton.isEnabled = false
        doneButton.tintColor = .white
        self.navigationItem.setRightBarButton(addButton, animated: true)
        self.navigationItem.setLeftBarButton(doneButton, animated: true)
        changeCellButton(isHidden: false)
        
    }
    
    private func changeCellButton(isHidden: Bool) {
        didSelectItemAtIsEnabled = isHidden
        if let indexPaths = myCollectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = myCollectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.isEditingClose = isHidden
                    
                }
            }
        }
    }
}

// MARK: - Collection DataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemAtIsEnabled {
            presenter.showDetail(film: presenter.myMyvies[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.myMyvies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        myCell.setupViews()
        myCell.configureMovieCell(movie: presenter.myMyvies[indexPath.row])
        myCell.delegate = self
        return myCell
    }
}

extension MainViewController: CollectionViewCellDelegate {
    func delete(cell: CollectionViewCell) {
        if let indexPath = myCollectionView?.indexPath(for: cell) {
            let myMovie = presenter.myMyvies[indexPath.item]
            presenter.myMyvies.remove(at: indexPath.item)
            presenter.delete(film: myMovie)
            
            myCollectionView?.deleteItems(at: [indexPath])
        }
    }
}

extension MainViewController: MainViewProtocol {
    
}
