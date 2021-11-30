//
//  ViewController.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 18/11/21.
//

import UIKit

class ViewController: UIViewController{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadingView: ReusableLoadingItemViewCell?
    var isLoading = false
    
    var viewModel: MoviesCollectionViewModelProtocol! {
        didSet {
            self.viewModel.didTapCell = { [unowned self] identifier in
                self.performSegue(withIdentifier: identifier, sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        let screenWidth = UIScreen.main.bounds.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth) // (1.5 * screenWidth) ficou com uma proporção não muito boa
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        // Register item cell
        let itemCellNib = UINib(nibName: "ItemViewCell", bundle: nil)
        self.collectionView.register(itemCellNib, forCellWithReuseIdentifier: "itemviewid")

        // Register loading cell (infinity loading)
        let loadingReusableNib = UINib(nibName: "ReusableLoadingItemViewCell", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingreusableviewid")
        
        viewModel = MoviesCollectionViewModel(
            api: DependencyManager.resolve(MovieService.self)
        )

        // First data fetch
        viewModel.didGetMovies()
        
        // Callback called when didGetMovies() is successful
        viewModel.reloadCollectionView = { [weak self] in
                    DispatchQueue.main.async {
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                        self?.collectionView.reloadData()
                        self?.isLoading = false
                    }
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == viewModel.movieDetailsIdentifier {
            // Passing movieId to view controller
            let vc = segue.destination as? MovieDetailViewController
            vc?.movieID = viewModel.selectedMovieId//
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Item tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = viewModel.movies[indexPath.row].id.map(String.init) ?? ""
        viewModel.selectedMovieId = movieId
        viewModel.goToHomeDetails()
    }
    
    // Size of collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    // Setup and update cell item view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemviewid", for: indexPath) as! ItemViewCell        
        
        let url = URL(string: "https://image.tmdb.org/t/p/w200" + viewModel.movies[indexPath.row].poster_path!)
        let data = try? Data(contentsOf: url!)
        
        // Recycle cell changing the current image for each index
        if(data != nil){
            cell.poster.contentMode = UIView.ContentMode.scaleToFill
            cell.poster.image = UIImage(data: data!)
            
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Fetch more data
        if indexPath.row == viewModel.movies.count - 10 && !self.isLoading {
            loadMoreData()
        }
    }

    // Fetch more data
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task
                sleep(2)
                self.viewModel.didGetMovies()
            }
        }
    }    
    
    // Fix cell size when is loading
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }

    // Setup footer view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingreusableviewid", for: indexPath) as! ReusableLoadingItemViewCell
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    // Handle animation activation
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    // Handle animation deactivation
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }

}

