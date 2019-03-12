//
//  CreatorsTableViewController.swift
//  MarvelHeroes
//
//  Created by ket on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class CreatorsTableViewController: UITableViewController {

    let marvelCreatorsViewModel = CreatorsViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
    private var filteredCreators = [Creator]()
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
        marvelCreatorsViewModel.updateCreators { (error) in
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

    // cet up the search controller
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Creators"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)]
        let textFieldInsideSearchBarLabel = searchController.searchBar.textField.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = .black

        searchController.searchBar.textField.addTarget(self, action: #selector(goToWeb), for: UIControl.Event.primaryActionTriggered)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // selector of search controller
    @objc func goToWeb() {
        print("WEB")
    }

    // pagination spiner func
    func createSpinner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        spinner.color = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
        tableView.tableFooterView = spinner
    }

    // pull-to-refresh func
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func reloadData() {
        marvelCreatorsViewModel.clearCreators()
        tableView.reloadData()
        marvelCreatorsViewModel.updateCreators { (error) in
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
        let alert = UIAlertController(title: "Ops..", message: "Hero not found!", preferredStyle: .alert )
        let alertAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(alertAction)
        alert.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        alert.view.layer.cornerRadius = 10
        self.present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let creatorLink = marvelCreatorsViewModel.getCreatorInfoLink(forIndexPath: indexPath)
        // go to creator info web page
        self.performSegue(withIdentifier: "goToCreatorInfo", sender: URL(string: creatorLink))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCreators.count
        }
        return marvelCreatorsViewModel.allCreatorsData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CreatorsTableViewCell
        //cell.updateCell(withResults: marvelCreatorsViewModel.allCreatorsData[indexPath.row])

        if isFiltering {
            cell.updateCell(withResults: filteredCreators[indexPath.row])
        } else {
            cell.updateCell(withResults: marvelCreatorsViewModel.allCreatorsData[indexPath.row])
        }
        return cell
    }

    // pagination cells
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(tableView.contentOffset.y + tableView.frame.size.height, tableView.contentSize.height)
        if (tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height, scrollView.isDragging, paginationFlag, !marvelCreatorsViewModel.allCreatorsData.isEmpty {
            paginationFlag = false
            spinner.startAnimating()
            // pagination data
            marvelCreatorsViewModel.updateCreators { (error) in
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
        let creatorsWebVC = segue.destination as? CreatorsWebVC
        creatorsWebVC?.creatorLink = sender as? URL
    }
}

extension CreatorsTableViewController: UISearchResultsUpdating, UISearchBarDelegate{

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
            filteredCreators = marvelCreatorsViewModel.allCreatorsData.filter({(creators: Creator) -> Bool in
                return creators.fullName.lowercased().contains(searchText.lowercased())
            })
        } else if scope == "In Web" {
            print("Внутри In Web")
            marvelCreatorsViewModel.getSearchCreators(heroName: searchText) { results in
                if results != nil {
                    self.filteredCreators = results!
                    self.tableView.reloadData()
                } else if !self.filteredCreators.isEmpty && searchText != "" {
                    self.alertSearchHander()
                }
            }
        }

        tableView.reloadData()
    }
}

extension UISearchBar {

    var textField: UITextField {
        guard let txtField = self.value(forKey: "searchField") as? UITextField else {
            assertionFailure()
            return UITextField()
        }
        return txtField
    }

}
