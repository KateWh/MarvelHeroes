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

    // get seaching comics
    func getSearchComics(heroName name: String, completionHandler: @escaping([Comics]?) -> Void) {
        ComicsCommunicator.getSearchComics(withName: name) { result in
            switch result {
            case .success(let allAboutComics):
                completionHandler(allAboutComics.data.results)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }
}
