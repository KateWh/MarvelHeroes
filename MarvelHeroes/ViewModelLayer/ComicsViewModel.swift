//
//  Comics.swift
//  MarvelHeroes
//
//  Created by vit on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

class ComicsViewModel {
    
    var allComicsData: [Comics] = []
    var limitComics = 0
    var offsetComics = 0

    let searchController = UISearchController(searchResultsController: nil)
    var filteredComics = [Comics]()
    var selectedScopeState = "In Phone"
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    // get comics data
    func updateComics(complitionHandler: @escaping (Error?) -> Void) {
        ComicsCommunicator.getComics(withLimit: 20, withOffset: offsetComics) { (result) in
            switch result {
            case .success(let allAboutComics):
                self.allComicsData += allAboutComics.data.results
                self.limitComics = allAboutComics.data.limit
                self.offsetComics = allAboutComics.data.offset + allAboutComics.data.limit
                complitionHandler(nil)
            case .failure(let error):
                complitionHandler(error)
                
            }
        }
    }
    
    // clear comics data
    func clearComics() {
        allComicsData.removeAll()
        offsetComics = 0
    }
    
    // get link with comics info
    func getComicsInfoLink(forIndexPath indexPath: IndexPath) -> String {
        var comicsInfoLink = ""
        // fing "detail" link
        for url in allComicsData[indexPath.row].urls {
            if url.type == "detail" {
                comicsInfoLink = url.url
            }
        }
        // add "s" to "http", because source link looks like "http" asd iOS is angry 😡 !
        comicsInfoLink.insert("s", at: comicsInfoLink.index(comicsInfoLink.startIndex, offsetBy: 4))
        return comicsInfoLink
    }


    // filter content by searching text
    func filterContentForSearchText(_ searchText: String, scope: String, complitionHandler: @escaping (Error?) -> Void) {
        if scope == "In Phone" {
            filteredComics = self.allComicsData.filter({(comics: Comics) -> Bool in
                return comics.title.lowercased().contains(searchText.lowercased())
            })
            complitionHandler(nil)
        } else if scope == "In Web", searchText != "" {

            // start spinner inside searchBarTextField
            searchController.searchBar.isLoading = true
            searchController.searchBar.activityIndicator!.color = #colorLiteral(red: 0.8240086436, green: 0.08994806558, blue: 0.1957161427, alpha: 1)
            searchController.searchBar.activityIndicator?.backgroundColor = #colorLiteral(red: 0.9310250282, green: 0.8915370107, blue: 0.03296109289, alpha: 1)

            // search hero in web
            ComicsCommunicator.getSearchComics(withName: searchText) { result in
                switch result {
                case .success(let filteredComics):
                    self.filteredComics = filteredComics.data.results
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
