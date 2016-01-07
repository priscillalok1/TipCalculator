//
//  ViewController.swift
//  tips
//
//  Created by Priscilla Lok on 1/6/16.
//  Copyright (c) 2016 Priscilla Lok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentSlideBar: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var resultsView: UIView!
    
    @IBOutlet weak var minTipLabel: UILabel!
    @IBOutlet weak var maxTipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        
        
        billField.text = ""
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey("defaultTip") == nil
        {
            defaults.setObject("20", forKey: "defaultTip")
        }
        let defaultTipStr = NSString(string:defaults.stringForKey("defaultTip")!)
        var defaultFloat = defaultTipStr.floatValue
        tipPercentSlideBar.value = defaultFloat
        //tipPercentSlideBar.setValue(22.0, animated: true)
        tipPercentLabel.text = defaultTipStr as String
        
        
        if defaults.stringForKey("minTip") == nil
        {
            defaults.setObject("10", forKey: "minTip")
        }
        let minTipStr = NSString(string:defaults.stringForKey("minTip")!)
        tipPercentSlideBar.minimumValue = minTipStr.floatValue
        minTipLabel.text = minTipStr as String
        println(minTipStr)
        
        if defaults.stringForKey("maxTip") == nil
        {
            defaults.setObject("30", forKey: "maxTip")
        }
        let maxTipStr = NSString(string:defaults.stringForKey("maxTip")!)
        tipPercentSlideBar.maximumValue = maxTipStr.floatValue
        maxTipLabel.text = maxTipStr as String
        
        tipPercentSlideBar.setNeedsDisplay()
        
    }
    

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func applicationDidBecomeActive()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        var lastBillDate = defaults.objectForKey("lastBillDate") as! NSDate
        var now = NSDate()
        
        //calculate how long it's been since application was last inactive
        var interval = now.timeIntervalSinceDate(lastBillDate)
       // var interval =  now.timeIntervalSinceReferenceDate(lastBillDate as NSDate)
        
        //if time elapsed is less than 10 min, resume last bill amount and tip percentage
        //else clear bill amount field
        if interval < 600
        {
            billField.text = defaults.valueForKey("lastBillAmount") as! String
            let lastTipPercentStr = NSString(string:defaults.stringForKey("lastTipPercent")!)
            var lastTipPercentFloat = lastTipPercentStr.floatValue
            tipPercentSlideBar.value = lastTipPercentFloat
        }
        else
        {
            billField.text = ""
        }
        
    }
    
    func applicationWillResignActive ()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey:"lastBillDate")
        defaults.setObject(tipPercentLabel.text, forKey: "lastTipPercent")
        defaults.setObject(billField, forKey: "lastBillAmount")
    }

  /*  func updateViewWithAnimation(animated: Boolean)
    {
        let billFieldString = NSString(string:billField.text)
        var billAmount  = billFieldString.doubleValue
        
        if billAmount == 0
        {
            showInputOnlyView()
        }
        else
        {
            showResultsView()
        }
    }
    
    func showInputOnlyView ()
    {
        
        //slide down the tip value and total fields
        tipPercentSlideBar.alpha = 0
        let rect = resultsView.frame
        resultFrame.origin.y = 300
        
    }
    func showResultsView ()
    {
        
    }*/

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        updateTipAndTotal()

    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        var currentValue = Int(tipPercentSlideBar.value)
        //println(currentValue)
        tipPercentLabel.text = "\(currentValue)"
        
        updateTipAndTotal()
        
    }
    
    func updateTipAndTotal()
    {
        let billFieldString = NSString(string:billField.text)
        var billAmount  = billFieldString.doubleValue
        let tipPercentString = NSString(string:tipPercentLabel.text!)
        var tipPercent = tipPercentString.doubleValue * 0.01
        var tip = billAmount * tipPercent
        var total = billAmount + tip
        
        tipLabel.text = "$\(tip)"
        totalLabel.text = "$\(total)"
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

