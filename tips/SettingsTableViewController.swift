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
        let backItem = UIBarButtonItem(title: "Custom", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(defaultTipField.text, forKey: "defaultTip")
        defaults.setObject(minTipField.text, forKey: "minTip")
        defaults.setObject(maxTipField.text, forKey: "maxTip")
        
        //check to make sure input makes sense
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }



}
