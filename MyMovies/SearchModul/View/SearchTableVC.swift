//
//  SearchTableVC.swift
//  ViewedMovies
//
//  Created by Данила on 10.05.2022.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func alertOk(title: String, message: String)
    func reloadTable()
    func reloadCell(_ index: IndexPath)
}

final class SearchTableVC: UIViewController {
    private let presenter: SearchPresenterProtocol
    
    private var myTableView = UITableView()
    private var timer = Timer()

    
    // MARK: - Initialize Method
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        settingTableView()
        settingNC()
    }
    
    // MARK: - Private method
    private func settingTableView() {
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(TableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = 144.0
        myTableView.backgroundColor = .black
        
        view.addSubview(myTableView)
    }
    
    private func settingNC() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

// MARK: - TableVC Delegate
extension SearchTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        presenter.showDetail(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCountOfMovie()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! TableViewCell
        let model = presenter.getTableModel(index: indexPath)
        cell.configureFilmCell(model)
        return cell
    }
}

// MARK: - Search Delegate
extension SearchTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if text != "" {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                let filmName = text!.replacingOccurrences(of: " ", with: "%20")
                self?.presenter.searchFilm(filmName) // "harry%20potter"
            })
        }
    }
}

// MARK: - SearchViewProtocol
extension SearchTableVC: SearchViewProtocol {
    func alertOk(title: String, message: String) {
        let alet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alet.addAction(ok)
        present(alet, animated: true, completion: nil)
    }
    
    func reloadTable() {
        myTableView.reloadData()
    }
    
    func reloadCell(_ index: IndexPath) {
        myTableView.reloadRows(at: [index], with: .none)
    }
}
