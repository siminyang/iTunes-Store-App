//
//  DetailListViewModel.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/3.
//

import Combine
import Alamofire
import Foundation

class DetailListViewModel {
    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var hasMoreData = true

    private let searchArtist: String
    private var currentSongOffset = 0
    private let pageSize = 36
    private var cancellables = Set<AnyCancellable>()
    private let likeManager: LikeManaging

    init(initialSongs: [Song], searchArtist: String, likeManager: LikeManaging) {
        self.songs = initialSongs
        self.searchArtist = searchArtist
        self.currentSongOffset = initialSongs.count
        self.likeManager = likeManager
    }

    func loadMoreSongs() -> AnyPublisher<[Song], Error> {
        guard !isLoading && hasMoreData else {
            return Empty().eraseToAnyPublisher()
        }
        isLoading = true

        let songsURL = "https://itunes.apple.com/search?term=\(searchArtist)&media=music&limit=\(pageSize)&offset=\(currentSongOffset)"

        return AF.request(songsURL).publishDecodable(type: SongResponse.self)
            .subscribe(on: DispatchQueue.global())
            .tryMap { response -> [Song] in
                guard let songResponse = response.value else {
                    throw NSError(domain: "SongResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode song response"])
                }
                return songResponse.results
            }
            .handleEvents(receiveOutput: { [weak self] newSongs in
                guard let self = self else { return }
                self.songs.append(contentsOf: newSongs)
                self.currentSongOffset += newSongs.count
                self.hasMoreData = newSongs.count >= self.pageSize
            }, receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .eraseToAnyPublisher()
    }
    
    func toggleLike(for song: Song) {
        likeManager.toggleLike(for: song)
    }

    func isLiked(for song: Song) -> Bool {
        return likeManager.isLiked(for: song)
    }
}
