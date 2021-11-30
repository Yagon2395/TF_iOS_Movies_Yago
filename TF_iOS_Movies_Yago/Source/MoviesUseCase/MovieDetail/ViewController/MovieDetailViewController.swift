//
//  MovieDetailViewController.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 22/11/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            self.viewModel.didUpdateView = { [weak self] model in
                self?.didUpdateView(with: model)
            }

            self.viewModel.didUpdateImageView = { [weak self] imageURL in
                self?.moviePoster.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
    }
    
    
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    var movieID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MovieDetailViewModel(
            api: DependencyManager.resolve(MovieService.self)
        )

        viewModel.didGetMovieDetail(id: movieID ?? String())
        
    }
    
    func didUpdateView(with model: MovieDetailDTO) {
        movieTitle.text = model.title
        movieDescription.text = model.overview
    }

}

