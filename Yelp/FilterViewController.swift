//
//  FilterViewController.swift
//  Yelp
//
//  Created by Bryan Pon on 9/21/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    
    func filterViewControllerSearchButtonClicked(filterViewController: FilterViewController)
}

enum FilterType {
    case Toggle
    case Select
}

struct FilterSection {
    var title: String
    var type: FilterType
    var settings: Array<String>
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FilterViewControllerDelegate!
    
    let filterSettings = [
        FilterSection(title: "Most Popular", type: FilterType.Toggle, settings: ["Open Now", "Hot & New", "Offering a Deal", "Delivery"]),
        FilterSection(title: "Distance", type: FilterType.Select, settings: ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]),
        FilterSection(title: "Sort by", type: FilterType.Select, settings: ["Best Match", "Distance", "Highest Rated"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSettings[section].settings.count
    }
    
    func cellForFilterType(filterType: FilterType) -> FilterCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        switch (filterType) {
        case FilterType.Toggle:
            cell.accessoryView = UISwitch(frame: CGRectZero)
        case FilterType.Select:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterSection = filterSettings[indexPath.section]
        let cell = cellForFilterType(filterSection.type)
        cell.settingLabel.text = filterSection.settings[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 8, width: 304, height: 18))
        headerLabel.font = UIFont.systemFontOfSize(16)
        headerLabel.text = filterSettings[section].title
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 34))
        headerView.backgroundColor = UIColor.lightGrayColor()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSettings.count
    }
    
    @IBAction func onSearchButtonClicked(sender: AnyObject) {
        delegate.filterViewControllerSearchButtonClicked(self)
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
