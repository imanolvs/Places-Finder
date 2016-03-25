//
//  ReviewsViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 15/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

private let FLT_MAX = CGFloat(1000)

class ReviewsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var numberReviews : UILabel!
    @IBOutlet weak var overallRating : CosmosView!
    
    var placeName : String!
    var rating : Double!
    
    var authorName : [String]!
    var ratings : [Double]!
    var reviewText : [String]!
    var timeInterval : [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = placeName
        numberReviews.text = "\(authorName.count) reviews"
        overallRating.rating = rating
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    private func configureCell(cell: ReviewCell, indexPath: NSIndexPath) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yy"
        let date = NSDate(timeIntervalSince1970: timeInterval[indexPath.row])
        
        cell.authorName.text = authorName[indexPath.row]
        cell.ratingView.rating = ratings[indexPath.row]
        cell.textReview.text = reviewText[indexPath.row]
        cell.dateLabel.text =  dateFormatter.stringFromDate(date)
        
        let myString = NSString(string: reviewText[indexPath.row])
        let maxSize = CGSize(width: cell.frame.width, height: FLT_MAX)
        let rect = myString.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 14)!], context: nil)
        
        cell.textReview.frame = rect
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return authorName.count
    }
            
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") as! ReviewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
