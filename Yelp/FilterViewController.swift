//
//  FilterViewController.swift
//  Yelp
//
//  Created by Bryan Pon on 9/21/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    
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
    
    weak var delegate: FilterViewControllerDelegate?
    
    let filterSettings = [
        FilterSection(title: "General", type: FilterType.Toggle, settings: ["Offering a Deal"]),
        FilterSection(title: "Distance", type: FilterType.Select, settings: ["Auto", "1 km", "5 km", "10 km", "25 km"]),
        FilterSection(title: "Sort by", type: FilterType.Select, settings: ["Best Match", "Distance", "Highest Rated"])
    ]
    
    let radius = [40000, 1000, 5000, 10000, 25000]
    
    var toggleStates: Dictionary<Int, Bool> = [:]
    
    var selectedStates: Dictionary<Int, Int> = [:]
    
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
    
    func cellForFilterTypeAtIndexPath(filterType: FilterType, indexPath: NSIndexPath) -> FilterCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as FilterCell
        switch (filterType) {
        case FilterType.Toggle:
            let toggle = UISwitch(frame: CGRectZero)
            toggle.tag = tagForIndexPath(indexPath)
            toggle.addTarget(self, action: "onSwitchToggled:", forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = toggle
        case FilterType.Select:
            if (indexPath.row == 0) {
                cell.setSelected(true, animated: true)
                selectedStates[indexPath.section] = indexPath.row
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterSection = filterSettings[indexPath.section]
        let cell = cellForFilterTypeAtIndexPath(filterSection.type, indexPath: indexPath)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedStates[indexPath.section] = indexPath.row
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSettings.count
    }
    
    @IBAction func onSearchButtonClicked(sender: AnyObject) {
        delegate?.filterViewControllerSearchButtonClicked(self)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func onSwitchToggled(sender: UISwitch) {
        toggleStates.removeValueForKey(sender.tag)
        if (sender.on) {
            toggleStates[sender.tag] = true
        }
    }
    
    func tagForIndexPath(indexPath: NSIndexPath) -> Int {
        return indexPath.section * 100 + indexPath.row
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
