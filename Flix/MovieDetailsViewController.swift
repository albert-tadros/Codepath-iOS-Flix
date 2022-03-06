//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by ALBERT TADROS on 3/4/22.
//

import UIKit
import AlamofireImage


class MovieDetailsViewController: UIViewController {
    
    var movieDetails : [String:Any]!  // this is a property assigned to the class. note the use of ":" after movie. This will contain the selected movie data passed from the main viewcontroller

    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        // loading title and overview
        titleLabel.text = movieDetails["title"] as? String
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movieDetails["overview"] as? String
        synopsisLabel.sizeToFit()
        
        //loading images
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movieDetails["poster_path"] as! String
        let posterURL = URL(string: baseURL +  posterPath)!
        
        let backdropPath = movieDetails["backdrop_path"] as! String
        let backdropURL = URL(string: baseURL +  backdropPath)!
        
        print("Poster URL:", posterURL)
        posterView.af.setImage(withURL: posterURL)
        backdropView.af.setImage(withURL: backdropURL)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(<#T##@objc method#>))
//        posterView.addGestureRecognizer(tap)
        
    }
    
    
    // Bonus
    
//     @objc override func prepare(segue: UIStoryboardSegue, sender: Any?) {
//
//        print("Tapping happened")
//        // Find the selected movies    (through the sender)
//        let movieId = movieDetails["id"] as! Int // getting data of selected movie through its indexpath
//        print(movieId)
//        // pass the selected movie details to the details screen (through the segue)
//
//        let trailerViewController = segue.destination as! TrailerViewController // object to the class MovieDetailsViewController to access its properties
//        trailerViewController.movieId =  movieId
//    }
    
    
    @IBAction func didTapGes(_ sender: UITapGestureRecognizer) {
        print("Tapping happened, insdie @IBACTion")
        performSegue(withIdentifier: "trailerNavigation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("Inside prepare")
            
        if segue.identifier == "trailerNavigation" {
           let movieId = movieDetails["id"] as! Int
           print(movieId)
           let trailerViewController = segue.destination as! TrailerViewController
           trailerViewController.movieId =  movieId
        }
    }
}

