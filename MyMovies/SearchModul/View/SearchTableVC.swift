//
//  SearchTableVC.swift
//  ViewedMovies
//
//  Created by Данила on 10.05.2022.
//

import UIKit

class SearchTableVC: UIViewController {
    
    var presenter:  SearchPresenterProtocol!
    
    var myTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        settingTableView()
        settingNC()
    }
    
    
    func settingTableView() {
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(TableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = 144.0
        myTableView.backgroundColor = .black
        
        self.view.addSubview(myTableView)
    }
    
    func settingNC() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func alertOk(title: String, message: String) {
        let alet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alet.addAction(ok)
        present(alet, animated: true, completion: nil)
    }
    
}

// MARK: - TableVC Delegate
extension SearchTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print(self.presenter.films)
        presenter.showDetail(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! TableViewCell
        let film = presenter.films[indexPath.row]
        
        let urlString = film.imageStr
        
        NetworkRequest.shared.requestDataPoster(urlString: urlString) {[weak self] result in
            switch result {
            case .success(let data):
                self?.presenter.films[indexPath.row].imageData = data
                cell.setImage(imageData: data)
            case .failure(let error):
                let filmLogo = UIImage(named: "filmLogo")?.pngData()
                self?.presenter.films[indexPath.row].imageData = filmLogo
                cell.setImage(imageData: filmLogo!)
                print("No film logo" + error.localizedDescription)
            }
        }
        
        cell.configureFilmCell(film: film)
        return cell
    }
}

// MARK: - Search Delegate
extension SearchTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if text != "" {
            presenter.timer.invalidate()
            presenter.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                let filmName = text!.replacingOccurrences(of: " ", with: "%20")
                self?.presenter.searchFilm(filmName: "harry%20potter" ) // "harry%20potter" filmName
            })
        }
    }
}

extension SearchTableVC: SearchViewProtocol {
    
}
