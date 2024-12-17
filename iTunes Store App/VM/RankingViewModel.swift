//
//  RankingViewModel.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import Foundation
import Combine
import Alamofire

class RankingViewModel {
    @Published var songs: [Song] = []
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var error: Error?

    // "周興哲""Taylor Swift""Maroon 5"
    private let searchArtist = "Yoasobi"
    private let pageSize = 36
    private var cancellables = Set<AnyCancellable>()
    private let likeManager: LikeManaging

    init(likeManager: LikeManaging = LikeManager()) {
        self.likeManager = likeManager
    }

    func fetchData() {
        isLoading = true

        let songsURL = "https://itunes.apple.com/search?term=\(searchArtist)&media=music&limit=\(pageSize)&offset=0"
        let albumsURL = "https://itunes.apple.com/search?term=\(searchArtist)&entity=album&limit=\(pageSize)&offset=0"

        let songPublisher = AF.request(songsURL).publishDecodable(type: SongResponse.self)
        let albumPublisher = AF.request(albumsURL).publishDecodable(type: AlbumResponse.self)

        Publishers.Zip(songPublisher, albumPublisher)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.error = error
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] (songResponse, albumResponse) in
                guard let songResponse = songResponse.value,
                      let albumResponse = albumResponse.value else {
                    self?.error = songResponse.error ?? albumResponse.error
                    self?.isLoading = false
                    return
                }

                self?.songs = songResponse.results
                self?.albums = albumResponse.results
            })
            .store(in: &cancellables)
    }

    func createDetailListViewModel() -> DetailListViewModel {
        return DetailListViewModel(initialSongs: songs, searchArtist: searchArtist, likeManager: likeManager)
    }

    func toggleLike(for song: Song) {
        likeManager.toggleLike(for: song)
    }

    func isLiked(for song: Song) -> Bool {
        return likeManager.isLiked(for: song)
    }
}
