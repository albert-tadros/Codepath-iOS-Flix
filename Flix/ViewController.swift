//
//  ViewController.swift
//  Flix
//
//  Created by ALBERT TADROS on 2/27/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies  = [[String:Any]]() // an array of dictionaries to store movies data from api
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        print("Hello")
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                 
                 self.tableView.reloadData() // asking tableview to keep reloading after fetching took its time and happened, then tableView should recieve data for (movies.count).In initial rendering, tableView does not recieve any movies.count because fetching didn't happend at this point.
                 
                 // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

             }
        }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // it returns the number of rows(cells) in table
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // it returns the content to be viewed in each row(cell)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        
        let title = movie["original_title"] as! String // getting movie title
        let synopsis = movie["overview"] as! String // getting overview
        
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL +  posterPath)!
        
        print("Poster URL:", posterURL)
        cell.posterView.af.setImage(withURL: posterURL)
        
        return cell
    }


}

