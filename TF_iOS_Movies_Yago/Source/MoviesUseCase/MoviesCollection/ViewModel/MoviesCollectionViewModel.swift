//
//  MoviesCollectionViewModel.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 20/11/21.
//

import Foundation

protocol MoviesCollectionViewModelProtocol: AnyObject {
    var currentPage: Int { get set }
    var reloadCollectionView: (() -> Void)? { get set }
    var movieDetailsIdentifier: String { get }
    var didTapCell: ((_ identifier: String) -> Void)? { get set }
    var api: MovieService { get set }
    var movies:[MovieDTO] { get set }
    var selectedMovieId:String { get set }
    init(api: MovieService)
    func goToHomeDetails()
    func didGetMovies()
}

class MoviesCollectionViewModel: MoviesCollectionViewModelProtocol {
    var currentPage = 1
    var reloadCollectionView: (() -> Void)?
    var movieDetailsIdentifier = "MovieDetailViewController"
    var movies=[MovieDTO]()
    var selectedMovieId: String = ""
    var api: MovieService

    required init(api: MovieService) {
        self.api = api
    }
    
    var didTapCell: ((String) -> ())?

    func goToHomeDetails() {
        didTapCell?(movieDetailsIdentifier)
    }
    
    func didGetMovies() {

        api.getMoviesTopRated(page: currentPage) { result in
            switch result {
            case .success(let data):
                if(data.results?.count ?? 0 > 0){
                    self.movies.append(contentsOf: data.results!)
                    self.reloadCollectionView!()
                    self.currentPage = self.currentPage + 1
                }                   
                    
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }

}
