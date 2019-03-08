//
//  ModelOfComics.swift
//  MarvelHeroes
//
//  Created by ket on 3/6/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

struct ComicsDataWrapper: Decodable {
    let data: ComicsData
}

struct ComicsData: Decodable {
    let offset: Int
    let limit: Int
    let results: [Comics]
}

struct Comics: Decodable {
    let id: Int
    let title: String
    let format: String
    let pageCount: Int
    let thumbnail: Thumbnail
    let characters: CharacterInCurrentComics
    let series: [String: String]
    let stories: Story
    let creators: CreatorOfComics
    let urls: [comicsUrl]
}

struct Thumbnail: Decodable {
    let path: String
    let `extension`: String
}

struct CharacterInCurrentComics: Decodable {
    let available: Int
}

struct Story: Decodable {
    let available: Int
}

struct CreatorOfComics: Decodable {
    let available: Int
}

struct comicsUrl: Decodable {
    let type: String
    let url: String
}
