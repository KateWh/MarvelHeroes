//
//  ModelOfCreators.swift
//  MarvelHeroes
//
//  Created by ket on 3/6/19.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation

struct CreatorsDataWrapper: Decodable {
    let data: CreatorsData
}

struct CreatorsData: Decodable {
    let offset: Int
    let limit: Int
    let results: [Creator]
}

struct Creator: Decodable {
    let id: Int
    let fullName: String
    let thumbnail: CreatorThumbnail
    let comics: ComicsItems
    let series: SeriesItem
    let stories: StoriesItem
    let events: Event
    let urls: [detailUrl]
}

struct CreatorThumbnail: Decodable {
    let path: String
    let `extension`: String
}

struct ComicsItems: Decodable {
    let available: Int
    let items: [Item]
}

struct SeriesItem: Decodable {
    let available: Int
}

struct StoriesItem: Decodable {
    let available: Int
}

struct Event: Decodable {
    let available: Int
}

struct Item: Decodable {
    let name: String
}

struct detailUrl: Decodable {
    let type: String
    let url: String
}
