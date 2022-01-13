//
//  ViewController.swift
//  FirstTask
//
//  Created by abd on 31/12/2021.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var textFiled : UITextField!
    
    
    var movies : MoviesModel = MoviesModel(results: [])
    var networkBrain = NetworkBrain()
       
    @IBAction func getNextPage(_ sender: Any) {
        getMoreMovies ()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        
        networkBrain.getMoviesList { [weak self] result in
            switch (result){
            case.success(let data):
                self?.movies = data
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            
            case .failure(_):
                return
            }
            
        }
        
    }

    func getMoreMovies () {
        networkBrain.pageNumber = networkBrain.pageNumber + 1
        
        networkBrain.getMoviesList { [weak self] result  in
            switch (result){
            case.success(let data):
                self?.movies = data
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            
            case .failure(_):
                return
            }
            
        }
    }

}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset.y
        if p > (collectionView.contentSize.height-100-scrollView.frame.size.height){}
        print("buttom")
        getMoreMovies ()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(self.movies.results.count)
        
        return movies.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
//        print(self.movies.results.count)

        cell.setup(with: movies.results[indexPath.row])
        
        return cell
    }
    

    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print(self.movies.results.count)
        return CGSize(width: view.frame.width/2 - 5, height: 300)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
              
        let vc = storyboard?.instantiateViewController(identifier: "MovieView") as! MovieDetailViewController
        
        vc.id = movies.results[indexPath.row].id
        vc.modalPresentationStyle = .automatic
        
        present(vc, animated: true)

    }
  
}

