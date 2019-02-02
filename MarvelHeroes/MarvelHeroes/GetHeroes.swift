//
//  GetHeroes.swift
//  MarvelHeroes
//
//  Created by vit on 1/31/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

//--------------------------------------------------
struct ComicsComicId: Decodable {
    let data: heroData
}

struct heroData: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let id: Int
    let name: String
    let thumbnail: ImageLink
    let comics: Comics
    let series: Series
    let stories: Stories
    let events: Events
    let urls: [HeroInfo]
}

struct Comics: Decodable {
    let available: Int
    let items: [Item]
    struct Item: Decodable {
        var name: String
    }
}

struct ImageLink: Decodable {
    let path: String
    let `extension`: String
}

struct HeroInfo: Decodable {
    let type: String
    let url: String
}
struct Series: Decodable {
    let available: Int
}
struct Stories: Decodable {
    let available: Int
}
struct Events: Decodable {
    let available: Int
}
//-------------------------------------------------


class GetHeroes {
    var allAboutHero: [Results] = []
    
    func getHeroes(withLimit limit: Int, completionHandler: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?limit=" + String(limit) + "&ts=1&apikey=7fcabde7c43d136312c02ddd457b5585&hash=59d26685428cdfe4e89e35ca8e90038a") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let myFile = try decoder.decode(ComicsComicId.self, from: data)
                self.allAboutHero = myFile.data.results
                completionHandler(error)
            } catch {
                print(error)
            }
            }.resume()
    }
    
}
