//
//  MoviesViewController.swift
//  fLickz
//
//  Created by Simrandeep Singh on 2/6/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var refreshControl: UIRefreshControl?
    
    var movies: [NSDictionary]?
    
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(endpoint == "now_playing"){
            self.navigationItem.title = "Now Playing"
        }
        else{
            self.navigationItem.title = "Top Rated"
        }
        
        if let navigationBar = navigationController?.navigationBar {
            
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 0.15, green: 0.15, blue: 0.4, alpha: 0.8)
            ]
        }

        
        
        // hide and resize error message initially
        errorView.isHidden = true
        errorView.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView.isHidden = false
        
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
 
        loadDataFromNetwork( reload: false )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /* function for database call */
    func loadDataFromNetwork( reload: Bool) {
        
        // url and fetch request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + endpoint + "?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        
        let session = URLSession(
            configuration: .default,
            delegate: nil,
            delegateQueue: OperationQueue.main)
        
        if (reload)  {
            
        } else {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // if there was an error
                Thread.sleep(forTimeInterval: 2)
                self.errorCall(error: error)
            } else if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // update the class global movie data
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    // update the table
                    self.tableView.reloadData()
                    
                    
                    if (reload) {
                        // Tell the refreshControl to stop spinning
                        self.refreshControl?.endRefreshing()
                    }
                    else {
                        // Hide HUD once the network request comes back
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
    // In case the network call fails
    func errorCall(error: Error){
        MBProgressHUD.hide(for: self.view, animated: true)
        self.refreshControl?.endRefreshing()
        errorView.isHidden = false
        errorView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
    
    @IBAction func onErrorTap() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadDataFromNetwork(reload: true)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadDataFromNetwork(reload: true)
    }
    
    
    
    /* functions for creating the cell */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            // idea that didn't pan out --- maybe
            // hide and resize error message since network request succeeded
            errorView.isHidden = true
            errorView.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
            tableView.isHidden = false
            
            return movies.count
        } else {
            // idea that didn't pan out
            // tableView.isHidden = true
            // errorView.isHidden = false
            // errorView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // Use a image pattern when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "eyes")!)
        cell.selectedBackgroundView = backgroundView
        
        // set cell's info
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let poster  = movie["poster_path"] as! String
        let basePosterURL = baseUrl + poster
        
        let posterURL = NSURL(string: basePosterURL)
        
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(posterURL as! URL)
        
        
        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        tableView.deselectRow(at: indexPath!, animated: true)
        
        let movie = movies![(indexPath?.row)!]
        
        
        let detailViewController = segue.destination as! DetailedViewController
        
        detailViewController.movie = movie
        

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    

}
