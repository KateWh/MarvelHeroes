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

    func getHeroes(withLimit limit: Int, withOffset offset: Int, completionHandler: @escaping (Result<CharacterDataWrapper>) -> Void) {

        let url = "https://gateway.marvel.com:443/v1/public/characters?limit=" + String(limit) + "&offset=" + String(offset + limit) + "&ts=1&apikey=7fcabde7c43d136312c02ddd457b5585&hash=59d26685428cdfe4e89e35ca8e90038a"

        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let receivedData = try decoder.decode(CharacterDataWrapper.self, from: data)
                    completionHandler(.success(receivedData))
                } catch {
                    completionHandler(.failure(error))
                    print(error)
                }
            }
        }

    }
    
}
