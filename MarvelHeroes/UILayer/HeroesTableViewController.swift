//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import SDWebImage
import FAPanels

class HeroesTableViewController: UITableViewController {

    let marvelHeroesViewModel = HeroesViewModel()
    
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
    
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
                self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
            }
        }
        
        // call pull-to-refresh
        addRefreshControl()
        
        // Setup the Scope Bar
        marvelHeroesViewModel.searchController.searchBar.scopeButtonTitles = ["In Phone", "In Web"]
        marvelHeroesViewModel.searchController.searchBar.delegate = self
    }

    // Set up the search controller
    func setupSearchController() {
        marvelHeroesViewModel.searchController.searchResultsUpdater = self
        marvelHeroesViewModel.searchController.obscuresBackgroundDuringPresentation = false
        marvelHeroesViewModel.searchController.searchBar.placeholder = "Search Heroes"
        marvelHeroesViewModel.searchController.searchBar.tintColor = UIColor(cgColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1))
        marvelHeroesViewModel.searchController.searchBar.backgroundColor = #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)]
        navigationItem.searchController = marvelHeroesViewModel.searchController
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
        let heroInfoLink = marvelHeroesViewModel.getHeroInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: heroInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if marvelHeroesViewModel.isFiltering {
            return marvelHeroesViewModel.filteredHeroes.count
        }
        return marvelHeroesViewModel.allHeroesData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell

        if marvelHeroesViewModel.isFiltering {
            cell.updateCell(withResults: marvelHeroesViewModel.filteredHeroes[indexPath.row])
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
                    self.alertHandler(withTitle: "Attention!", withMassage: "Data not resieved!", titleForActionButton: "Understand", withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
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
        self.marvelHeroesViewModel.selectedScopeState = searchBar.scopeButtonTitles![selectedScope]
        updateSearchResults(for: marvelHeroesViewModel.searchController)
    }


    // called when user input text to search field
    func updateSearchResults(for searchController: UISearchController) {
        marvelHeroesViewModel.filterContentForSearchText(searchController.searchBar.text!, scope: marvelHeroesViewModel.selectedScopeState) {
            error in
            if error == nil {
                searchController.searchBar.isLoading = false
                 self.tableView.reloadData()
            } else {
                self.alertHandler(withTitle: "Ops..", withMassage: "Heroes not found!", titleForActionButton: "Try again!", withColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
                self.marvelHeroesViewModel.searchController.searchBar.isLoading = false
            }
        }
    }

    
}

extension UISearchBar {

    // Access to textField
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

   //  Create activity indicator
    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }

    //  on/off activity indicator
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                 // Set up activity indicator
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .white)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
    
}
