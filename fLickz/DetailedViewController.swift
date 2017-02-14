//
//  DetailedViewController.swift
//  fLickz
//
//  Created by Simrandeep Singh on 2/7/17.
//  Copyright © 2017 Sim Singh. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var avgRatingNavItem: UINavigationItem!
    
    let offset = 40 as CGFloat
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let movie_rating_num = movie["vote_average"] as! Float
        let movie_rating = String(movie_rating_num)
        
        avgRatingNavItem.title = avgRatingNavItem.title! + movie_rating

        
        // get movie info
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        // get and set movie's poster
        if let poster  = movie["poster_path"] as? String {
            let basePosterURL = baseUrl + poster
            
            let posterURL = NSURL(string: basePosterURL)
            self.posterImageView.setImageWith(posterURL as! URL)
        }
        
        self.titleLabel.text = title
        self.overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        infoView.frame = CGRect(x: infoView.frame.origin.x, y: infoView.frame.origin.y, width: infoView.frame.width, height: overviewLabel.frame.height + offset)
 
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height + offset + offset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
