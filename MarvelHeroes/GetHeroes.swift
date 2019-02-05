//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import Alamofire

class GetHeroes {
    var allAboutHero: [Hero] = []
    var offsetNumOfGetHero = 0

    func getHeroes(withLimit limit: Int, completionHandler: @escaping (Error?) -> Void) {
        let url = "https://gateway.marvel.com:443/v1/public/characters?limit=" + String(limit) + "&offset=" + String(offsetNumOfGetHero) + "&ts=1&apikey=7fcabde7c43d136312c02ddd457b5585&hash=59d26685428cdfe4e89e35ca8e90038a"
        offsetNumOfGetHero += limit
        if offsetNumOfGetHero > 1490 {
            offsetNumOfGetHero = 0
        }

        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(ComicsComicId.self, from: data)
                    self.allAboutHero = receivedData.data.results
                    completionHandler(nil)
                } catch {
                    print(error)
                    completionHandler(error)
                }
            }
        }

    }
    
}
