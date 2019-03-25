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
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
   
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
                self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
            }
        }

        // call pull-to-refresh
        addRefreshControl()

        // Setup the Scope Bar
        marvelComicsViewModel.searchController.searchBar.scopeButtonTitles = ["In Phone", "In Web"]
        marvelComicsViewModel.searchController.searchBar.delegate = self
    }

    // Set up the search controller
    func setupSearchController() {
        marvelComicsViewModel.searchController.searchResultsUpdater = self
        marvelComicsViewModel.searchController.obscuresBackgroundDuringPresentation = false
        marvelComicsViewModel.searchController.searchBar.placeholder = "Search Comics"
        marvelComicsViewModel.searchController.searchBar.tintColor = #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)]
        navigationItem.searchController = marvelComicsViewModel.searchController
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
                self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }

    func alertHandler(withTitle title: String, withMassage massage: String, titleForActionButton titleOfButton: String, withColor color: UIColor) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert )
        let alertAction = UIAlertAction(title: titleOfButton, style: .default, handler: nil)
        alert.addAction(alertAction)
        alert.view.backgroundColor = color
        alert.view.layer.cornerRadius = 10
        self.present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comicsInfoLink = marvelComicsViewModel.getComicsInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToComicsInfo", sender: URL(string: comicsInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if marvelComicsViewModel.isFiltering {
            return marvelComicsViewModel.filteredComics.count
        }
        return marvelComicsViewModel.allComicsData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComicsTableViewCell

        if marvelComicsViewModel.isFiltering {
            cell.updateCell(withResults: marvelComicsViewModel.filteredComics[indexPath.row])
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
                    self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
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
        self.marvelComicsViewModel.selectedScopeState = searchBar.scopeButtonTitles![selectedScope]
        updateSearchResults(for: marvelComicsViewModel.searchController)
    }


    // called when user input text to search field
    func updateSearchResults(for searchController: UISearchController) {
        marvelComicsViewModel.filterContentForSearchText(searchController.searchBar.text!, scope: marvelComicsViewModel.selectedScopeState) {
            error in
            if error == nil {
                self.tableView.reloadData()
                searchController.searchBar.isLoading = false
            } else {
                self.alertHandler(withTitle: "Ops..", withMassage: "Heroes not found!", titleForActionButton: "Try again!", withColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                self.marvelComicsViewModel.searchController.searchBar.isLoading = false
            }
        }
    }


}
