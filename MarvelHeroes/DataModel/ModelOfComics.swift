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
    let thumbnail: Thumbnail
}

struct Thumbnail: Decodable {
    let path: String
    let `extension`: String
}
