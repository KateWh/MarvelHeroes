//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import SDWebImage

class HeroesTableVC: UITableViewController {
    let marvelHeroesViewModel = HeroesViewModel()
    var spinner = UIActivityIndicatorView()
    var paginationFlag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // create spinner to refresh footer animation
        createSpiner()
        
        tableView.separatorColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        marvelHeroesViewModel.updateData { (error) in
            if error == nil {
                self.tableView.reloadData()
            }
        }
        addRefreshControl()
    }

    func createSpiner() {
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        spinner.color = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
        tableView.tableFooterView = spinner
    }

    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func reloadData() {
        marvelHeroesViewModel.limit = 20
        marvelHeroesViewModel.offset = 0
        marvelHeroesViewModel.updateData { (error) in
            if error == nil {
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Attention!", message: error.debugDescription, preferredStyle: .alert )
                let alertAction = UIAlertAction(title: "Understand ;ь", style: .default, handler: nil)
                alert.addAction(alertAction)
                alert.view.backgroundColor = UIColor(red: 250 , green: 100, blue: 150, alpha: 1.0)
                alert.view.tintColor = UIColor(red: 250, green: 100, blue: 150, alpha: 1.0)
                alert.view.layer.cornerRadius = 15
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
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
        if (tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height, paginationFlag{
            paginationFlag = false
            spinner.startAnimating()
            // reload data
            self.marvelHeroesViewModel.prepareToPagination()
            marvelHeroesViewModel.updateData { (error) in
                guard error == nil else { return }
                self.marvelHeroesViewModel.addPaginationData()
                self.paginationFlag = true
                self.tableView.reloadData()
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebVC = segue.destination as? WebVC
        WebVC?.heroLink = sender as? URL
    }
    
}
