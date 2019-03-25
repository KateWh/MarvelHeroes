

//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

class HeroesViewModel {

    var allHeroesData: [Hero] = []
    var limitHero = 0
    var offsetHero = 0

    let searchController = UISearchController(searchResultsController: nil)
    var filteredHeroes = [Hero]()
    var selectedScopeState = "In Phone"
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }


    // get heroes data
    func updateHeroes(complitionHandler: @escaping (Error?) -> Void) {
        CharatersCommunicator.getHeroes(withLimit: 20, withOffset: offsetHero) { (result) in
            switch result {
            case .success(let allAboutHero):
                self.allHeroesData += allAboutHero.data.results
                self.limitHero = allAboutHero.data.limit
                self.offsetHero = allAboutHero.data.offset + allAboutHero.data.limit
                complitionHandler(nil)
            case .failure(let error):
                complitionHandler(error)

            }
        }
    }

    // clear heroes data
    func clearHeroes() {
        allHeroesData.removeAll()
        offsetHero = 0
    }

    // get link with hero info
    func getHeroInfoLink(forIndexPath indexPath: IndexPath) -> String {
        var heroInfoLink = ""
        // find preffered "wiki" link
        for url in allHeroesData[indexPath.row].urls {
            if url.type == "wiki" {
                heroInfoLink = url.url
                break
            } else {
                heroInfoLink = url.url
            }
        }
        // add "s" to "http", because source link looks like "http", and iOS is angry 😡!
        heroInfoLink.insert("s", at: heroInfoLink.index(heroInfoLink.startIndex, offsetBy: 4))
        return heroInfoLink
    }


    // filter content by searching text
    func filterContentForSearchText(_ searchText: String, scope: String, complitionHandler: @escaping (Error?) -> Void) {
        if scope == "In Phone" {
            filteredHeroes = self.allHeroesData.filter({(hero: Hero) -> Bool in
                return hero.name.lowercased().contains(searchText.lowercased())
            })
            complitionHandler(nil)
        } else if scope == "In Web", searchText != "" {

            // start spinner inside searchBarTextField
                searchController.searchBar.isLoading = true
                searchController.searchBar.activityIndicator!.color = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
                searchController.searchBar.activityIndicator?.backgroundColor = #colorLiteral(red: 0.5859692693, green: 0.04976465553, blue: 0.05334877968, alpha: 1)

            // search hero in web
            CharatersCommunicator.getSearchHero(withName: searchText) { result in
                switch result {
                case .success(let filteredHeroes):
                   self.filteredHeroes = filteredHeroes.data.results
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

