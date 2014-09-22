//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var client: YelpClient!
    var results: [NSDictionary] = []
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        doSearch("food")
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        let name = result["name"] as String
        let reviewCount = result["review_count"] as Int
        let reviewsPlural = reviewCount == 1 ? "" : "s"
        let location = result["location"] as NSDictionary
        let addressLines = location["address"] as Array<String>
        let neighborhoods = location["neighborhoods"] as? Array<String>
        let addressTokens = neighborhoods == nil || neighborhoods!.isEmpty ? addressLines : addressLines + [neighborhoods![0]]
        let address = ", ".join(addressTokens)
        let categoryGroups = result["categories"] as Array<Array<String>>
        let categories = ", ".join(categoryGroups.map {a -> String in a[0]})
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as SearchResultCell
        let mainImageRequest = NSURLRequest(URL: NSURL(string: result["image_url"] as String))
        cell.mainImageView.setImageWithURLRequest(mainImageRequest, placeholderImage: UIImage(named: "main-image-placeholder"),
            success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                cell.mainImageView.image = image
            }, failure: nil
        )
        cell.ratingsView.setImageWithURL(NSURL(string: result["rating_img_url"] as String))
        cell.titleLabel.text = "\(indexPath.row + 1). \(name)"
        cell.reviewsLabel.text = "\(reviewCount) Review\(reviewsPlural)"
        cell.addressLabel.text = address
        cell.categoriesLabel.text = categories
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch(searchBar.text)
        searchBar.endEditing(true)
    }
    
    func doSearch(searchText: String) {
        if !searchText.isEmpty {
            client.searchWithTerm(searchText, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                self.results = (response as NSDictionary)["businesses"] as [NSDictionary]
                self.tableView.reloadData()
                }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println(error)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        println("appeared")
    }
}

