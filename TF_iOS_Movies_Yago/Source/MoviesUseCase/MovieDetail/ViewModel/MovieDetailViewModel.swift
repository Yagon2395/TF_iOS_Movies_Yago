//
//  MovieDetailViewModel.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 30/11/21.
//

import Foundation

protocol MovieDetailViewModelProtocol: AnyObject {
    var api: MovieService { get set }
    var didUpdateView: ((MovieDetailDTO) -> Void)? { get set }
    var didUpdateImageView: ((URL) -> Void)? { get set }

    func didGetMovieDetail(id: String)
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {

    var didUpdateImageView: ((URL) -> Void)?
    var didUpdateView: ((MovieDetailDTO) -> Void)?

    var api: MovieService
    
    required init(api: MovieService) {
        self.api = api
    }

    func didGetMovieDetail(id: String) {

        api.getMovieBy(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.didUpdateView?(data)
                self?.didDownloadImage(
                    for: "https://image.tmdb.org/t/p/w200" + (data.poster_path ?? "")
                )
            case .failure(let error):
                print(error)
            }
        }
    }

    func didDownloadImage(for path: String) {

        api.downloadImage(imagePath: path) { [weak self] result in
            switch result {
            case .success(let imageURL):
                self?.didUpdateImageView?(imageURL)
            case .failure(let error):
                print(error)
            }

        }
    }
}
