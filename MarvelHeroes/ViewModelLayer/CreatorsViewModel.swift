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
}





















