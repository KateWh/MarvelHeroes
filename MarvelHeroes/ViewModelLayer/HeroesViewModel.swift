

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

}

