//
//  AutoCompleteTableView.swift
//  AutoCompleteTableViewDemo
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 Vijayvir. All rights reserved.
//

import UIKit

 @objc protocol AutoCompleteTableViewDelegate {
    optional func  autoCompleteTableView(tableView: AutoCompleteTableView, didAddItem: String) -> Array<String>
}


  class AutoCompleteTableView: UITableView , UITableViewDataSource, UITableViewDelegate
  {

    // MARK: - Properties
  
    var predictionArray : [String] = []
    
    var textField : UITextField?
          private var kvoContextOfScrollView: UInt8 = 1
   private var scrollViewOfTextField : UIScrollView?
    var showHighLightedText :(show:Bool , HighLightedColor : UIColor , normalColor : UIColor) = (true, UIColor.blueColor() ,UIColor.blackColor())
    

    
    var autoCompleteTableViewDelegate : AutoCompleteTableViewDelegate?
     //MARK: CLC : Class Life Cycle
    override init(frame: CGRect, style: UITableViewStyle)
    {
    
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        
    }
   // withOptionsDict : Dictionary<String ,String>?
   
    init(textfield: UITextField? , tfFrame: CGRect? , parentViewController : UIViewController? )
    {
        let frame : CGRect = CGRectMake(10, tfFrame!.origin.y + tfFrame!.size.height , UIScreen.mainScreen().bounds.size.width - 20 , 90)
        
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        let footView : UIView = UIView(frame: CGRectMake(10, 0, UIScreen.mainScreen().bounds.size.width - 20 , 1))
            footView.backgroundColor = UIColor.clearColor()
    
        self.tableFooterView = footView
        //self.hidden = true;
        parentViewController?.view.addSubview(self)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.scrollEnabled = true;
        
        // turn off standard correction
        textfield!.autocorrectionType = UITextAutocorrectionType.No;
        
     
        
         hideSelf()
    }
    
    required  init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
     override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        self.scrollViewOfTextField?.removeObserver(self, forKeyPath: "miles")
    }

    
    //MARK: -  Helper Function
    
      override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
      {
        if context == &kvoContextOfScrollView
        {
            if(keyPath! == "contentOffset")
            {
                
                if((self.textField) != nil){
                    updateFrameOfTableView()
                }
                
            }
            
        }
    }
    
    
 
    func setScrollView(scrollView : UIScrollView?){
        self.scrollViewOfTextField = scrollView
        self.scrollViewOfTextField?.addObserver(self, forKeyPath: "contentOffset",
            options:[NSKeyValueObservingOptions.New,NSKeyValueObservingOptions.Old], context: &kvoContextOfScrollView)
        
    }
    
    func updateFrameOfTableView()
    {
        let frame : CGRect = (textField!.window?.subviews[0].convertRect(textField!.frame, fromView: self.textField!.superview))!
        self.frame = CGRectMake(10, frame.origin.y + frame.size.height, (UIScreen.mainScreen().bounds.size.width - 20), 90);
        
        
     
    }
    func showSelf()
    {
        self.hidden = false;
    }
    
    func hideSelf()
    {
        self.hidden = true;
    }
    //MARK: - TextField Delegate
    func textFieldValueChanged(textFieldTemp: UITextField)
    {
        self.textField = textFieldTemp
     let frame : CGRect = (textFieldTemp.window?.subviews[0].convertRect(textFieldTemp.frame, fromView: textFieldTemp.superview))!
        self.frame = CGRectMake(10, frame.origin.y + frame.size.height, (UIScreen.mainScreen().bounds.size.width - 20), 90);
       let currentString  = textFieldTemp.text as String!


        
      if(currentString.characters.count > 0)
      {
        
        showSelf()
        var tempArray :[String] = []
        
        
        self.predictionArray =   (autoCompleteTableViewDelegate?.autoCompleteTableView!(self, didAddItem: "fdsfds")) ?? []
        for tempVale : String   in self.predictionArray
        {
            
            //            if string.rangeOfString("Swift") != nil{
            //                println("exists")
            //            }
            
            if tempVale.lowercaseString.rangeOfString(currentString!) != nil
            {
                tempArray += [tempVale];
            }
            
            
            
        }
        
        
        if(tempArray.count > 0)
        {
            self.predictionArray = tempArray
            
            self.reloadData()
        }
        else{
            hideSelf()
        }
        

        }
      else{
        hideSelf()
        }
        
    
    }

    //MARK: - UITableViewDataSource
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return predictionArray.count
     }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil
        {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        
        
    if(self.textField?.text?.characters.count>0)
    {
        if(showHighLightedText.show == true)
        {
            cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
            
            let initialtext =   "\(predictionArray[indexPath.row])"
            
           cell?.textLabel?.textColor = showHighLightedText.normalColor
            
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialtext)
            
            let range: NSRange = (initialtext as NSString).rangeOfString((self.textField?.text!)! , options: [NSStringCompareOptions.CaseInsensitiveSearch])
            
            
             attrString.addAttribute(NSForegroundColorAttributeName, value: showHighLightedText.HighLightedColor, range: range)
            
            
            cell!.textLabel?.attributedText = attrString
        }
        
        else{
            cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
            cell?.textLabel?.textColor = showHighLightedText.normalColor
        }
     
    }
    else
    {
        

    }
       
        return cell!
    }
    
    //MARK: - UITableViewDelegate
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        self.textField?.text = ("\(self.predictionArray[indexPath.row])")
         hideSelf()
        

        
        
    }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
    
}
