//
//  TrailerViewController.swift
//  Flix
//
//  Created by ALBERT TADROS on 3/5/22.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {
    
    
    var trailerData  = [[String:Any]]()
    var youtubeKey : String = ""
    var movieId : Int = 0
    let preKeyURL = "https://www.youtube.com/watch?v="
    var movieYoutubeURL : URL!
    let webview = WKWebView()
    
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webview)
        
        //print("I am in the trialer controller the movive id is ", movieId)
        
    // API Request for video trailers key
        
        let baseURL = "https://api.themoviedb.org/3/movie/"
        let movie_id = String(movieId)
        let postURL = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let trailerURL = URL(string: baseURL + movie_id + postURL)!
        
        let url = trailerURL
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let group = DispatchGroup()
        
        group.enter()
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 self.trailerData = dataDictionary["results"] as! [[String:Any]] // assining results dictionary to movies.. note the use of (as!)
                 
                 print("Trailer Data of movie" , self.trailerData)
                 //let youtubeKey = self.trailerData[0]["key"] as! String
                 //print("The movie Key is", self.trailerData[0]["name"])
                 
                 
                //print ("dicthinaory count",  self.trailerData[i]["type"])

                 self.youtubeKey = self.trailerData[0]["key"] as! String
                 self.movieYoutubeURL = URL(string: self.preKeyURL + self.youtubeKey)
                 
                 if self.youtubeKey != "" {
                     group.leave()
                 }

                 //print("The movie Key is", self.youtubeKey)
                 //print("movieYoutubeURL", self.movieYoutubeURL as Any)
                 //print(trailerURL)
                 //
        
             }
        }
        task.resume()

        group.notify(queue: .main) {
            //print("I am before guard")
            
            
            guard let youtubeURL = URL(string: "https://www.youtube.com/watch?v=" + self.youtubeKey) else {return}
            //print(youtubeURL)
            self.webview.load(URLRequest(url: youtubeURL))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.frame = view.bounds
    }

}
