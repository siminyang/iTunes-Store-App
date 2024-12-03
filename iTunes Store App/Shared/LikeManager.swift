//
//  LikeManager.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/3.
//

import Foundation

protocol LikeManaging {
    func toggleLike(for song: Song)
    func isLiked(for song: Song) -> Bool
}

class LikeManager: LikeManaging {
    private let likedItemsKey = "LikedItems"

    func toggleLike(for song: Song) {
        var likedItems = UserDefaults.standard.array(forKey: likedItemsKey) as? [Int] ?? []

        if likedItems.contains(song.trackId) {
            likedItems.removeAll { $0 == song.trackId }
        } else {
            likedItems.append(song.trackId)
        }

        UserDefaults.standard.set(likedItems, forKey: likedItemsKey)
    }

    func isLiked(for song: Song) -> Bool {
        let likedItems = UserDefaults.standard.array(forKey: likedItemsKey) as? [Int] ?? []

        return likedItems.contains(song.trackId)
    }
}
