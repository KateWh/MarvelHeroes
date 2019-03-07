//
//  DataModel.swift
//  MarvelHeroes
//
//  Created by ket on 06.02.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

struct CharacterDataWrapper: Decodable {
    let data: HeroesDataContainer
}

struct HeroesDataContainer: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let results: [Hero]
}

struct Hero: Decodable {
    let id: Int
    let name: String
    let thumbnail: ImageLink
    let comics: InfoComics
    let series: Series
    let stories: Stories
    let events: Events
    let urls: [HeroInfo]
}

struct InfoComics: Decodable {
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


