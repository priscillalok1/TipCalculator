//
//  SettingsTableViewController.swift
//  tips
//
//  Created by Priscilla Lok on 1/6/16.
//  Copyright (c) 2016 Priscilla Lok. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var defaultTipField: UITextField!
    @IBOutlet weak var minTipField: UITextField!
    @IBOutlet weak var maxTipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaultTipField.text = defaults.stringForKey("defaultTip")
        minTipField.text = defaults.stringForKey("minTip")
        maxTipField.text = defaults.stringForKey("maxTip")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = NSString(string:defaultTipField.text).intValue
        let minTip = NSString(string:minTipField.text).intValue
        let maxTip = NSString(string:maxTipField.text).intValue
        
        //error checking to make sure user input is valid
        if maxTip <= minTip
        {
            var alert : UIAlertView = UIAlertView(title: "Error", message: "Maximum Tip Percentage must be greater than Minimum Tip Percentage", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else if defaultTip < minTip || defaultTip > maxTip
        {
            var alert : UIAlertView = UIAlertView(title: "Error", message: "Default Tip Percentage is out of range between Minimum and Maximum Tip Percentages", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else //if input is valid, update settings parameters
        {
            defaults.setObject(defaultTipField.text, forKey: "defaultTip")
            defaults.setObject(minTipField.text, forKey: "minTip")
            defaults.setObject(maxTipField.text, forKey: "maxTip")
            dismissViewControllerAnimated(true, completion: nil)
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0
        {
            return 3
        }
        else if section == 1
        {
            return 2
        }
        else
        {
            return 0
        }
        
    }



}
