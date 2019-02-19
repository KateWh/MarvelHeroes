

//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

class HeroesViewModel {
    #warning ("Try to get rid this paginationData array and simplify business logic")
    var paginationData: [Hero] = []
    var allHeroesData: [Hero] = []
    var limit = 0
    var offset = 0
    
    // get heroes data
    func updateData(complitionHandler: @escaping (Error?) -> Void) {
        CharatersCommunicator.getHeroes(withLimit: 20, withOffset: offset) { (result) in
            switch result {
            case .success(let allAboutHero):
                self.allHeroesData = allAboutHero.data.results
                self.limit = allAboutHero.data.limit
                self.offset = allAboutHero.data.offset + allAboutHero.data.limit
                complitionHandler(result.error)
            case .failure(let error):
                print(error)
                complitionHandler(result.error)
            }
        }
    }
    #warning ("Think how you can avoid using of these two functions")
    func  prepareToPagination() {
        paginationData = allHeroesData
    }

    func addPaginationData() {
        self.paginationData += self.allHeroesData
        self.allHeroesData = self.paginationData
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
}

