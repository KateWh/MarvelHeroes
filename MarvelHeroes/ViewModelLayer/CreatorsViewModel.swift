//
//  CreatorsViewModel.swift
//  MarvelHeroes
//
//  Created by vit on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

class CreatorsViewModel {
    
    var allCreatorsData: [Creator] = []
    var limitCreators = 0
    var offsetCreators = 0

    let searchController = UISearchController(searchResultsController: nil)
    var filteredCreators = [Creator]()
    var selectedScopeState = "In Phone"
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    // get creators data
    func updateCreators(complitionHandler: @escaping (Error?) -> Void) {
        CreatorsCommunicator.getCreators(withLimit: 20, withOffset: offsetCreators) { (result) in
            switch result {
            case .success(let allAboutCreators):
                self.allCreatorsData += allAboutCreators.data.results
                self.limitCreators = allAboutCreators.data.limit
                self.offsetCreators = allAboutCreators.data.offset + allAboutCreators.data.limit
                complitionHandler(nil)
            case .failure(let error):
                complitionHandler(error)
                
            }
        }
    }
    
    // clear creators data
    func clearCreators() {
        allCreatorsData.removeAll()
        offsetCreators = 0
    }
    
    //get link with creator info
    func getCreatorInfoLink(forIndexPath indexPath: IndexPath) -> String {
        var creatorInfoLink = ""
        // find "detail" link
        for url in allCreatorsData[indexPath.row].urls {
            if url.type == "detail" {
                creatorInfoLink = url.url
            }
        }
        // add "s" to "http", because source link looks like "http", and iOS is angry 😡 !
        creatorInfoLink.insert("s", at: creatorInfoLink.index(creatorInfoLink.startIndex, offsetBy: 4))
        return creatorInfoLink
    }


    // filter content by searching text
    func filterContentForSearchText(_ searchText: String, scope: String, complitionHandler: @escaping (Error?) -> Void) {
        if scope == "In Phone" {
            filteredCreators = self.allCreatorsData.filter({(creators: Creator) -> Bool in
                return creators.fullName.lowercased().contains(searchText.lowercased())
            })
            complitionHandler(nil)
        } else if scope == "In Web", searchText != "" {

            // start spinner inside searchBarTextField
            searchController.searchBar.isLoading = true
            searchController.searchBar.activityIndicator!.color = #colorLiteral(red: 0.9988828301, green: 0.9734352231, blue: 0.06155067682, alpha: 1)
            searchController.searchBar.activityIndicator?.backgroundColor = #colorLiteral(red: 0.005948389415, green: 0.1200798824, blue: 0.001267887303, alpha: 1)

            // search hero in web
            CreatorsCommunicator.getSearchCreators(withName: searchText) { result in
                switch result {
                case .success(let filteredCreators):
                    self.filteredCreators = filteredCreators.data.results
                    complitionHandler(nil)
                case .failure(let error):
                    complitionHandler(error)
                }
            }

        } else {
            self.searchController.searchBar.isLoading = false
        }

    }

}


