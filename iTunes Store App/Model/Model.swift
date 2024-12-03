//
//  Model.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

struct Song: Codable, Hashable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
}

struct Album: Codable, Hashable {
    let collectionId: Int
    let collectionName: String
    let artistName: String
    let artworkUrl100: String
}

struct SongResponse: Codable {
    let resultCount: Int
    let results: [Song]
}

struct AlbumResponse: Codable {
    let resultCount: Int
    let results: [Album]
}
