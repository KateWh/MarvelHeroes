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
    
    let marvelHeroesViewModel = HeroesViewModel()
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroInfoLink = marvelHeroesViewModel.getHeroInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: heroInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marvelHeroesViewModel.allHeroesData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell
        cell.updateCell(withResults: marvelHeroesViewModel.allHeroesData[indexPath.row])

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
