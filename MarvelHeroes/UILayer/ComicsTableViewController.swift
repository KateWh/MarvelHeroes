//
//  ComicsTableViewController.swift
//  MarvelHeroes
//
//  Created by ket on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class ComicsTableViewController: UITableViewController {

    let marvelComicsViewModel = ComicsViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
    private var filteredComics = [Comics]()
    private var selectedScopeState = "In Phone"
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Call Search Controller
        setupSearchController()
        // create spinner to refresh footer animation
        createSpinner()

        // call get marvel heroes data
        marvelComicsViewModel.updateComics { (error) in
            if error == nil {
                self.tableView.reloadData()
            } else {
                self.alertHandler()
            }
        }

        // call pull-to-refresh
        addRefreshControl()

        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["In Phone", "In Web"]
        searchController.searchBar.delegate = self
    }

    // Set up the search controller
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Comics"
        searchController.searchBar.tintColor = #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)]
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // pagination spinner func
    func createSpinner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        spinner.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        tableView.tableFooterView = spinner
    }

    // pull-to-refresh func
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func reloadData() {
        marvelComicsViewModel.clearComics()
        tableView.reloadData()
        marvelComicsViewModel.updateComics { (error) in
            if error == nil {
                self.tableView.reloadData()
            } else {
                self.alertHandler()
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }

    func alertHandler() {
        let alert = UIAlertController(title: "Attention!", message: "Data not resieved!", preferredStyle: .alert )
        let alertAction = UIAlertAction(title: "Understand", style: .default, handler: nil)
        alert.addAction(alertAction)
        alert.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        alert.view.layer.cornerRadius = 10
        self.present(alert, animated: true, completion: nil)
    }

    func alertSearchHander() {
        let alert = UIAlertController(title: "Ops..", message: "Comics not found!", preferredStyle: .alert )
        let alertAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(alertAction)
        alert.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        alert.view.layer.cornerRadius = 10
        self.present(alert, animated: true, completion: nil)
        searchController.searchBar.isLoading = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comicsInfoLink = marvelComicsViewModel.getComicsInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToComicsInfo", sender: URL(string: comicsInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredComics.count
        }
        return marvelComicsViewModel.allComicsData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComicsTableViewCell

        if isFiltering {
            cell.updateCell(withResults: filteredComics[indexPath.row])
        } else {
            cell.updateCell(withResults: marvelComicsViewModel.allComicsData[indexPath.row])
        }
        return cell
    }

    // pagination cells
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(tableView.contentOffset.y + tableView.frame.size.height, tableView.contentSize.height)
        if (tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height, scrollView.isDragging, paginationFlag, !marvelComicsViewModel.allComicsData.isEmpty {
            paginationFlag = false
            spinner.startAnimating()
            // pagination data
            marvelComicsViewModel.updateComics { (error) in
                self.spinner.stopAnimating()
                self.paginationFlag = true
                guard error == nil else {
                    self.alertHandler()
                    return
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let comicsWebVC = segue.destination as? ComicsWebVC
        comicsWebVC?.comicsLink = sender as? URL
    }
}


extension ComicsTableViewController: UISearchResultsUpdating, UISearchBarDelegate{
    // this method is called when the scopeBar has changed
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("Я внутри selectedScopeButtonIndexDidChange")
        selectedScopeState = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

    // called when user input text to search field
    func updateSearchResults(for searchController: UISearchController) {
        print("Внутри updateSearchResults")
        filterContentForSearchText(searchController.searchBar.text!, scope: selectedScopeState)
    }

    // filter content by searching text
    private func filterContentForSearchText(_ searchText: String, scope: String) {
        print("Внутри filterContentForSearchText")
        print("scope: \(scope)")

        if scope == "In Phone" {
            print("Внутри In Phone")
            filteredComics = marvelComicsViewModel.allComicsData.filter({(comics: Comics) -> Bool in
                return comics.title.lowercased().contains(searchText.lowercased())
            })
        } else if scope == "In Web" {
            // start spinner inside searchBarTextField
            if searchController.searchBar.textField!.text != "" {
                searchController.searchBar.isLoading = true
                searchController.searchBar.activityIndicator?.color = #colorLiteral(red: 0.1126269036, green: 0.07627656838, blue: 0.01553396923, alpha: 1)
                searchController.searchBar.activityIndicator?.backgroundColor = #colorLiteral(red: 0.9310250282, green: 0.8915370107, blue: 0.03296109289, alpha: 1)
            } else {
                searchController.searchBar.isLoading = false
            }
            // search comics in web
            marvelComicsViewModel.getSearchComics(heroName: searchText) { results in
                if results != nil {
                    self.filteredComics = results!
                    self.tableView.reloadData()
                    self.searchController.searchBar.isLoading = false
                } else if !self.filteredComics.isEmpty && searchText != "" {
                    self.alertSearchHander()
                }
            }
        }

        tableView.reloadData()
    }
}
