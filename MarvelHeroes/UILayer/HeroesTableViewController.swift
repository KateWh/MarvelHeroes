//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import SDWebImage

class HeroesTableViewController: UITableViewController {

    private let marvelHeroesViewModel = HeroesViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var spinner = UIActivityIndicatorView()
    private var paginationFlag = true
    private var filteredHeroes = [Hero]()
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
        marvelHeroesViewModel.updateHeroes { (error) in
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
        searchController.searchBar.placeholder = "Search Heroes"
        searchController.searchBar.tintColor = UIColor(cgColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1))
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)]
        navigationItem.searchController = searchController
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
        marvelHeroesViewModel.clearHeroes()
        tableView.reloadData()
        marvelHeroesViewModel.updateHeroes { (error) in
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
        let heroInfoLink = marvelHeroesViewModel.getHeroInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: heroInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredHeroes.count
        }
        return marvelHeroesViewModel.allHeroesData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell

        if isFiltering {
            cell.updateCell(withResults: filteredHeroes[indexPath.row])
        } else {
            cell.updateCell(withResults: marvelHeroesViewModel.allHeroesData[indexPath.row])
        }
        return cell
    }

    // pagination cells
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(tableView.contentOffset.y + tableView.frame.size.height, tableView.contentSize.height)
        if (tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height, scrollView.isDragging, paginationFlag, !marvelHeroesViewModel.allHeroesData.isEmpty {
            paginationFlag = false
            spinner.startAnimating()
            // pagination data
            marvelHeroesViewModel.updateHeroes { (error) in
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
        let heroesWebVC = segue.destination as? HeroesWebVC
        heroesWebVC?.heroLink = sender as? URL
    }
    
}

extension HeroesTableViewController: UISearchResultsUpdating, UISearchBarDelegate{

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
            filteredHeroes = marvelHeroesViewModel.allHeroesData.filter({(hero: Hero) -> Bool in
                return hero.name.lowercased().contains(searchText.lowercased())
            })
        } else if scope == "In Web" {
            print("Внутри In Web")
            marvelHeroesViewModel.getSearchHero(heroName: searchText) { results in
                if results != nil {
                    self.filteredHeroes = results!
                    self.tableView.reloadData()
                } else if !self.filteredHeroes.isEmpty && searchText != "" {
                    self.alertSearchHander()
                }
            }
        }

        tableView.reloadData()
    }
}
