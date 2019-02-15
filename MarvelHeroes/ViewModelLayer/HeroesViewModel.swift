

//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

class HeroesViewModel {

    var allHeroesData: [Hero] = []
    var limit = 0
    var offset = 0

    func updateData(complitionHandler: @escaping (Bool) -> Void) {
        CharatersCommunicator.getHeroes(withLimit: 12, withOffset: offset  ) { (result) in
            switch result {
            case .success(let allAboutHero):
                self.allHeroesData += allAboutHero.data.results
                self.limit = allAboutHero.data.limit
                self.offset = allAboutHero.data.offset
                complitionHandler(true)
            case .failure(let error):
                print(error)
                complitionHandler(false)
            }
        }
    }

}

