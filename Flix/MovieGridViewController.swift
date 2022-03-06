//
//  MovieGridViewController.swift
//  Flix
//
//  Created by ALBERT TADROS on 3/5/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    //variables
    var movies = [[String:Any]]()
    
    // outlets
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

//        let widthofCell = (view.frame.size.width - (layout.minimumInteritemSpacing * 2)) / 3 // the width of one collection cell. note the divion by 3 indicates that each horizontal row (width)  in the collection view will carry 3 cells
//
//        layout.itemSize = CGSize(width: 140, height: 210 ) // the  math here is just for better layout
//
//        print("view.frame.size.width", widthofCell)
//
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/634649/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    //print(dataDictionary)

                    // TODO: Get the array of movies
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]] // assining results dictionary to movies.. note the use of (as!)
                 print("Movies Dic" , self.movies)
                 
                 self.collectionView.reloadData()

             }
        }
    task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item] // getting all data about the movie in cell with ( the given indexpath) 
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL +  posterPath)!
        
        cell.posterView.af.setImage(withURL: posterURL)
        
        return cell
    }
    
    
    // Bouns Question
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Loading up the details")
        
       
        
        // Find the selected movies    (through the sender)
        let cell = sender as! UICollectionViewCell   // the sender is the selected tableview cell
        let indexPath = collectionView.indexPath(for: cell)! // getting the indexpath of the selected cell
        let movie = movies[indexPath.row] // getting data of selected movie through its indexpath
         
        // pass the selected movie details to the details screen (through the segue)
        
        let detailsViewController = segue.destination as! MovieDetailsViewController // object to the class MovieDetailsViewController to access its properties
        detailsViewController.movieDetails = movie // PASS data from here to movieDetails property of the navigated screen (MovieDetailsViewController)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
    
    
    

}
