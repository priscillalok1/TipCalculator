//
//  ViewController.swift
//  tips
//
//  Created by Priscilla Lok on 1/6/16.
//  Copyright (c) 2016 Priscilla Lok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipPercentTextLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentSlideBar: UISlider!
    @IBOutlet weak var smileyFaceImage: UIImageView!
    @IBOutlet weak var sadfaceImage: UIImageView!
    
    
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var sectionSeparatorLine: UIView!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    @IBOutlet weak var resultsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up Observers to handle when user closes and reopens app
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillTerminate", name: UIApplicationWillTerminateNotification, object: nil)
        
        //immediately show keyboard upon opening app
        billField.becomeFirstResponder()
        
        
        
        //obtain default tip, min tip and max tip values from NSUserDefault to initiate tipPercentSlideBar
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey("defaultTip") == nil
        {
            defaults.setObject("20", forKey: "defaultTip") //if no value set for defaultTip, set it to 20
        }
        let defaultTipStr = NSString(string:defaults.stringForKey("defaultTip")!)
        let defaultFloat = defaultTipStr.floatValue
        tipPercentSlideBar.value = defaultFloat
        tipPercentLabel.text = defaultTipStr as String + "%"
        
        
        if defaults.stringForKey("minTip") == nil
        {
            defaults.setObject("10", forKey: "minTip")
        }
        let minTipStr = NSString(string:defaults.stringForKey("minTip")!)
        tipPercentSlideBar.minimumValue = minTipStr.floatValue
        
        if defaults.stringForKey("maxTip") == nil
        {
            defaults.setObject("30", forKey: "maxTip")
        }
        let maxTipStr = NSString(string:defaults.stringForKey("maxTip")!)
        tipPercentSlideBar.maximumValue = maxTipStr.floatValue
        tipPercentSlideBar.setNeedsDisplay()
        
        
        if defaults.stringForKey("lastTipPercent") == nil
        {
            defaults.setObject(defaults.stringForKey("defaultTip"), forKey: "maxTip")
        }
        //initiate billField and tip/total values to zero or nil if no record of lastBillAmount (this is cleared upon applicationWillTerminate)
        if defaults.valueForKey("lastBillAmount") == nil
        {
            billField.text = ""
            tipLabel.text = "$0.00"
            totalLabel.text = "$0.00"
        }
        else
        {
            updateValues()
        }
        tipPercentSlideBar.value = defaultFloat
        animateResultsView()
        
        
    }
    
    //this function is called when main screen appears after settings are set
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //set slideBar to reflect new min and max tip percent values
        tipPercentSlideBar.minimumValue = NSString(string:defaults.stringForKey("minTip")!).floatValue
        tipPercentSlideBar.maximumValue = NSString(string:defaults.stringForKey("maxTip")!).floatValue
        
        var defaultTip = NSString(string:defaults.stringForKey("defaultTip")!).floatValue
        var minTip = NSString(string:defaults.stringForKey("minTip")!).floatValue
        var maxTip = NSString(string:defaults.stringForKey("maxTip")!).floatValue
        
        //if last tip percent stored has a value
        if defaults.stringForKey("lastTipPercent") != nil
        {
            //reset slidebar value to reflect on new min to max scale
            var lastTipPercent = NSString(string:defaults.stringForKey("lastTipPercent")!).floatValue
            //if last tip percent stored is outside of current min and max range reset tip percent to default
            if lastTipPercent < minTip || lastTipPercent > maxTip
            {
                defaults.setObject(defaults.stringForKey("defaultTip"), forKey: "lastTipPercent")
                tipPercentSlideBar.value = defaultTip
                tipPercentLabel.text = NSString(string:defaults.stringForKey("defaultTip")!) as String + "%"
            }
            
        }
    
    }
    
    //when user exits app, reset tip percent and bill amount to initial values
    func applicationWillTerminate()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(defaults.stringForKey("defaultTip"), forKey: "lastTipPercent")
        defaults.setObject("", forKey: "lastBillAmount")

    }
    
    //save current values for time, tip percent, and bill amount when user closes app
    func applicationWillResignActive ()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey:"lastBillDate")
        defaults.setObject(tipPercentLabel.text, forKey: "lastTipPercent")
        defaults.setObject(billField.text, forKey: "lastBillAmount")
    }
    
    //when user reopens app after closing, values remain if time elapsed is less than 10 mins otherwise bill field resets to blank
    func applicationDidBecomeActive()
    {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("lastBillDate") == nil
        {
            defaults.setObject(NSDate(), forKey: "lastBillDate")
        }
        let lastBillDate = defaults.objectForKey("lastBillDate") as! NSDate
        let now = NSDate()
        
        //calculate how long it's been since application was last inactive
        let interval = now.timeIntervalSinceDate(lastBillDate)
        
        //if time elapsed is less than 10 min, resume last bill amount and tip percentage
        //else clear bill amount field
        if interval < 600
        {
            if defaults.valueForKey("lastBillAmount") == nil
            {
                defaults.setObject("", forKey: "lastBillAmount")
            }
            billField.text = defaults.valueForKey("lastBillAmount") as! String
            if defaults.stringForKey("lastTipPercent") == nil
            {
                defaults.setObject(tipPercentLabel.text, forKey: "lastTipPercent")
            }
            var lastTipPercentFloat = NSString(string:defaults.stringForKey("lastTipPercent")!).floatValue
            tipPercentSlideBar.value = lastTipPercentFloat
        }
        else
        {
            billField.text = ""
            tipPercentLabel.text = defaults.stringForKey("defaultTip")
        }
        updateValues()
        animateResultsView()
    }
    

    //when user changes bill field, update tip and total calculations
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateValues()
        //if bill field changes to empty string, fade out other fields
        if billField.text == ""
        {
            UIView.animateWithDuration(1.0, animations: {
                self.tipPercentTextLabel.alpha = 0
                self.tipPercentLabel.alpha = 0
                self.tipPercentSlideBar.alpha = 0
                self.smileyFaceImage.alpha = 0
                self.sadfaceImage.alpha = 0
                self.tipTextLabel.alpha = 0
                self.tipLabel.alpha = 0
                self.totalTextLabel.alpha = 0
                self.totalLabel.alpha = 0
                self.sectionSeparatorLine.alpha = 0
            })
        }

    }
    
    //update tip percent label when slidebar value is changed
    @IBAction func sliderValueChanged(sender: AnyObject)
    {
        var currentValue = Int(tipPercentSlideBar.value)
        tipPercentLabel.text = "\(currentValue)%"
        
        //save new tip percent to NSUserDefaults
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tipPercentLabel.text, forKey: "lastTipPercent")
        
        //recalculate tip and total amount after percent is changed
        updateValues()
        
    }
    
    //if bill field is blank, fade out other fields
    func animateResultsView()
    {
        if billField.text == ""
        {
            UIView.animateWithDuration(0, animations: {
                self.tipPercentTextLabel.alpha = 0
                self.tipPercentLabel.alpha = 0
                self.tipPercentSlideBar.alpha = 0
                self.smileyFaceImage.alpha = 0
                self.sadfaceImage.alpha = 0
                self.tipTextLabel.alpha = 0
                self.tipLabel.alpha = 0
                self.totalTextLabel.alpha = 0
                self.totalLabel.alpha = 0
                self.sectionSeparatorLine.alpha = 0
            })
            
        }
        else
        {
            UIView.animateWithDuration(0, animations: {
                self.tipPercentTextLabel.alpha = 1
                self.tipPercentLabel.alpha = 1
                self.tipPercentSlideBar.alpha = 1
                self.smileyFaceImage.alpha = 1
                self.sadfaceImage.alpha = 1
                self.tipTextLabel.alpha = 1
                self.tipLabel.alpha = 1
                self.totalTextLabel.alpha = 1
                self.totalLabel.alpha = 1
                self.sectionSeparatorLine.alpha = 1
            })
        }
    }
    
    //calculate values after tip percent or bill amount is changed
    func updateValues()
    {
        let billFieldString = NSString(string:billField.text)
        var billAmount  = billFieldString.doubleValue
        let tipPercentString = NSString(string:tipPercentLabel.text!)
        var tipPercent = tipPercentString.doubleValue * 0.01
        var tip = billAmount * tipPercent
        var total = billAmount + tip
        
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.stringFromNumber(total)
        

        tipLabel.text = "$\(tip)"
        totalLabel.text = "$\(total)"
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        
        
    }
    
    //exits out of digit keypad when user clicks outside keypad
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
        animateResultsView()
    }
    
    
    //remove observers upon exit
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

