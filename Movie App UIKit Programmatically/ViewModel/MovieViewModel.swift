//
//  MovieViewModel.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 31/01/23.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    
    private var network = NetworkManager()
    private var nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=dd961bfa9a816030820499683fe54a36"
    private var upcomingURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=dd961bfa9a816030820499683fe54a36"
    
    func getNowPlayingMovie() {
        network.fetchMovieDataFromAPI(url: nowPlayingURL, expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.nowPlaying = movie.results
                }
            }
        }
    }
    
    func getUpcomingMovie() {
        network.fetchMovieDataFromAPI(url: upcomingURL, expecting: MovieResponse.self) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.upcoming = movie.results
                }
            }
        }
    }
}
