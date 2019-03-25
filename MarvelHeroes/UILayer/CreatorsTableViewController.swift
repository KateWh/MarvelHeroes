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
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
  

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
                self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
            }
        }

        // call pull-to-refresh
        addRefreshControl()

        // Setup the Scope Bar
        marvelCreatorsViewModel.searchController.searchBar.scopeButtonTitles = ["In Phone", "In Web"]
        marvelCreatorsViewModel.searchController.searchBar.delegate = self
    }

    // Set up the search controller
    func setupSearchController() {
        marvelCreatorsViewModel.searchController.searchResultsUpdater = self
        marvelCreatorsViewModel.searchController.obscuresBackgroundDuringPresentation = false
        marvelCreatorsViewModel.searchController.searchBar.placeholder = "Search Creators"
        marvelCreatorsViewModel.searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)]
        navigationItem.searchController = marvelCreatorsViewModel.searchController
        definesPresentationContext = true
    }

    // pagination spinner func
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
        let creatorLink = marvelCreatorsViewModel.getCreatorInfoLink(forIndexPath: indexPath)
        // go to creator info web page
        self.performSegue(withIdentifier: "goToCreatorInfo", sender: URL(string: creatorLink))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if marvelCreatorsViewModel.isFiltering {
            return marvelCreatorsViewModel.filteredCreators.count
        }
        return marvelCreatorsViewModel.allCreatorsData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CreatorsTableViewCell

        if marvelCreatorsViewModel.isFiltering {
            cell.updateCell(withResults: marvelCreatorsViewModel.filteredCreators[indexPath.row])
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
                    self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
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
        self.marvelCreatorsViewModel.selectedScopeState = searchBar.scopeButtonTitles![selectedScope]
        updateSearchResults(for: marvelCreatorsViewModel.searchController)
    }


    // called when user input text to search field
    func updateSearchResults(for searchController: UISearchController) {
        marvelCreatorsViewModel.filterContentForSearchText(searchController.searchBar.text!, scope: marvelCreatorsViewModel.selectedScopeState) {
            error in
            if error == nil {
                self.tableView.reloadData()
                searchController.searchBar.isLoading = false
            } else {
                self.alertHandler(withTitle: "Ops..", withMassage: "Heroes not found!", titleForActionButton: "Try again!", withColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                self.marvelCreatorsViewModel.searchController.searchBar.isLoading = false
            }
        }
    }


}
