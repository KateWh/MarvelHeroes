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
    let results: [Creators]
}

struct Creators: Decodable {
    let id: Int
    let fullName: String
    let thumbnail: CreatorsThumbnail
}

struct CreatorsThumbnail: Decodable {
    let path: String
    let `extension`: String
}
