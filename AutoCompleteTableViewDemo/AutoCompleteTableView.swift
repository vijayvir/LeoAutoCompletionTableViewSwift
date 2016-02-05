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
    optional func  autoCompleteTableView(tableView: AutoCompleteTableView, textField: String , rangeExceed: Bool)
}


  class AutoCompleteTableView: UITableView , UITableViewDataSource, UITableViewDelegate
  {

    // MARK: - Properties
  
    var predictionArray : [String] = []
    
    var textField : UITextField?
          private var kvoContextOfScrollView: UInt8 = 1
    private var scrollViewOfTextField : UIScrollView?
    
    var showHighLightedText :(show:Bool , HighLightedColor : UIColor , normalColor : UIColor) = (false, UIColor.blueColor() ,UIColor.blackColor())
    
    var autoMultipleSelection : (Allow:Bool , separatedBy: String , range : Int) = (false,",",Int.max)
    
    var multipleSetioinArr : [String] = []
    
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
        
        
     
        textfield!.addTarget(self , action: "autoTextFieldEditingDidEnd:", forControlEvents: UIControlEvents.EditingDidEnd)
       
        textfield!.addTarget(self , action: "autoTextFieldEditingDidBegin:", forControlEvents: UIControlEvents.EditingDidBegin)
        
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
                
                if((self.textField) != nil)
                {
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
    func autoTextFieldValueChanged(textFieldTemp: UITextField)
    {
        self.textField = textFieldTemp
        
        let frame : CGRect = (textFieldTemp.window?.subviews[0].convertRect(textFieldTemp.frame, fromView: textFieldTemp.superview))!
        
        self.frame = CGRectMake(10, frame.origin.y + frame.size.height, (UIScreen.mainScreen().bounds.size.width - 20), 90);
        
        
       var currentString  = textFieldTemp.text as String!
   
        if(autoMultipleSelection.Allow == true)
        {
            
            let initialString = currentString as String!
            
            var initialStringArr = initialString.componentsSeparatedByString(autoMultipleSelection.separatedBy)
            
            let lastName: String? = initialStringArr.count > 0 ? initialStringArr[initialStringArr.count-1] : initialStringArr[0]
            
             currentString = lastName as String!
         
        }
        else
        {
            currentString  = textFieldTemp.text as String!
        }
        
      if(currentString?.characters.count > 0)
      {
        
        showSelf()
        
        var tempArray :[String] = []
        
        
        self.predictionArray =   (autoCompleteTableViewDelegate?.autoCompleteTableView!(self, didAddItem: "fdsfds")) ?? []
        
        for tempVale : String   in self.predictionArray
        {
            
         
            
            
             let range: NSRange = (tempVale as NSString).rangeOfString(currentString , options: [NSStringCompareOptions.CaseInsensitiveSearch])
            
            
            if(range.length>0)
            {
                    tempArray += [tempVale];
            }
            
        }
        
        
        if(tempArray.count > 0)
        {
            self.predictionArray = tempArray
            
            self.reloadData()
        }
        else
        {
            hideSelf()
        }
        

        }
      else
      {
        hideSelf()
    }
        
    
    }
    
    func autoTextFieldEditingDidBegin(textFieldTemp: UITextField){
        if(autoMultipleSelection.Allow == true)
        {
            
            if(self.textField?.text != nil)
            {
                
                if(self.textField?.text != "")
                {
                    let initialString = self.textField?.text as String!
                    
                    var initialStringArr = initialString.componentsSeparatedByString(autoMultipleSelection.separatedBy)
                    
                    var tempString : String = ""
                    
                    for( var i = 0 ; i <= initialStringArr.count-1 ; i++  )
                    {
                        
                        tempString += ("\(initialStringArr[i])" + "\(autoMultipleSelection.separatedBy)")
                        
                        self.textField?.text = ""
                        
                        self.textField?.text = tempString
                    }
                }
                else{
                    self.textField?.text = ""
                }
                
         }
            
    }
        
    }
    func autoTextFieldEditingDidEnd(textFieldTemp: UITextField){
        
        if(autoMultipleSelection.Allow == true)
        {
           
            
            
            let initialString = self.textField?.text as String!
            
            var initialStringArr = initialString.componentsSeparatedByString(autoMultipleSelection.separatedBy)
            
            let lastName: String? = initialStringArr.count > 0 ? initialStringArr[initialStringArr.count-1] : initialStringArr[0]
            
            let  currentString = lastName as String!
           
            if(currentString == "")
            {
                var tempString : String = ""
                
                for( var i = 0 ; i < initialStringArr.count-1 ; i++  )
                {
                    if(i == initialStringArr.count-2 )
                    {
                        tempString += ("\(initialStringArr[i])")
                    }
                    else{
                        tempString += ("\(initialStringArr[i])" + "\(autoMultipleSelection.separatedBy)")
                    }
                }
                
                self.textField?.text = ""
               
                self.textField?.text = tempString
            }
            
        }
    
        
        hideSelf()
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
            
            
            if(autoMultipleSelection.Allow == true)
            {
                let initialString = self.textField?.text as String!
               
                var initialStringArr = initialString.componentsSeparatedByString(autoMultipleSelection.separatedBy)
                
                let lastName: String? = initialStringArr.count > 0 ? initialStringArr[initialStringArr.count-1] : initialStringArr[0]
                
               let  currentString = lastName as String!
                
                
                cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
                
                let initialtext =   "\(predictionArray[indexPath.row])"
                
                cell?.textLabel?.textColor = showHighLightedText.normalColor
                
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialtext)
                
                let range: NSRange = (initialtext as NSString).rangeOfString(currentString , options: [NSStringCompareOptions.CaseInsensitiveSearch])
                
                
                attrString.addAttribute(NSForegroundColorAttributeName, value: showHighLightedText.HighLightedColor, range: range)
                
                
                cell!.textLabel?.attributedText = attrString
                
                
            }
            else{
                cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
                
                let initialtext =   "\(predictionArray[indexPath.row])"
                
                cell?.textLabel?.textColor = showHighLightedText.normalColor
                
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialtext)
                
                let range: NSRange = (initialtext as NSString).rangeOfString((self.textField?.text!)! , options: [NSStringCompareOptions.CaseInsensitiveSearch])
                
                
                attrString.addAttribute(NSForegroundColorAttributeName, value: showHighLightedText.HighLightedColor, range: range)
                
                
                cell!.textLabel?.attributedText = attrString
            }
           
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

        if(autoMultipleSelection.Allow == true)
        {
            var tempString : String = ""
            
            let initialString = self.textField?.text as String!
           
            var initialStringArr = initialString.componentsSeparatedByString(autoMultipleSelection.separatedBy)
          
            self.textField?.text = ""

            for( var i = 0 ; i <= initialStringArr.count-2 ; i++  )
            {
                tempString += ("\(initialStringArr[i])" + "\(autoMultipleSelection.separatedBy)")
            }
            
            if(initialStringArr.count <= autoMultipleSelection.range)
            {
                tempString += "\(self.predictionArray[indexPath.row])" + " \(autoMultipleSelection.separatedBy)"
                
                self.textField?.text = tempString
                
            }
            else
            {
                autoCompleteTableViewDelegate?.autoCompleteTableView!(self,textField: tempString , rangeExceed: true)
                 self.textField?.text = tempString
            }
            
            
        }
        else
        {
       
            self.textField?.text = ("\(self.predictionArray[indexPath.row])")
        
            hideSelf()
        }
    
    }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
     {
      
        return 25
    }
}
