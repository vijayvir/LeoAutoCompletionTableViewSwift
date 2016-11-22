//
//  AutoCompleteTableView.swift
//  AutoCompleteTableViewDemo
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 Vijayvir. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


 @objc protocol AutoCompleteTableViewDelegate {
    @objc optional func  autoCompleteTableView(_ tableView: AutoCompleteTableView, didAddItem: String) -> Array<String>
    @objc optional func  autoCompleteTableView(_ tableView: AutoCompleteTableView, textField: String , rangeExceed: Bool)
}


  class AutoCompleteTableView: UITableView , UITableViewDataSource, UITableViewDelegate
  {

    // MARK: - Properties
  
    var predictionArray : [String] = []
    
    var textField : UITextField?
          fileprivate var kvoContextOfScrollView: UInt8 = 1
    fileprivate var scrollViewOfTextField : UIScrollView?
    
    var showHighLightedText :(show:Bool , HighLightedColor : UIColor , normalColor : UIColor) = (false, UIColor.blue ,UIColor.black)
    
    var autoMultipleSelection : (Allow:Bool , separatedBy: String , range : Int) = (false,",",Int.max)
    
    var multipleSetioinArr : [String] = []
    
    var autoCompleteTableViewDelegate : AutoCompleteTableViewDelegate?
    
    //MARK: CLC : Class Life Cycle
    override init(frame: CGRect, style: UITableViewStyle)
    {
    
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        
    }
   // withOptionsDict : Dictionary<String ,String>?
   
    init(textfield: UITextField? , tfFrame: CGRect? , parentViewController : UIViewController? )
    {
        let frame : CGRect = CGRect(x: 10, y: tfFrame!.origin.y + tfFrame!.size.height , width: UIScreen.main.bounds.size.width - 20 , height: 90)
        
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        let footView : UIView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20 , height: 1))
            footView.backgroundColor = UIColor.clear
    
        self.tableFooterView = footView
        //self.hidden = true;
        parentViewController?.view.addSubview(self)
        
        self.backgroundColor = UIColor.white
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.isScrollEnabled = true;
        
        // turn off standard correction
        textfield!.autocorrectionType = UITextAutocorrectionType.no;
        
        
     
        textfield!.addTarget(self , action: #selector(AutoCompleteTableView.autoTextFieldEditingDidEnd(_:)), for: UIControlEvents.editingDidEnd)
       
        textfield!.addTarget(self , action: #selector(AutoCompleteTableView.autoTextFieldEditingDidBegin(_:)), for: UIControlEvents.editingDidBegin)
        
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
    
      override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
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
    
    
 
    func setScrollView(_ scrollView : UIScrollView?){
       
        self.scrollViewOfTextField = scrollView
       
        self.scrollViewOfTextField?.addObserver(self, forKeyPath: "contentOffset",
            options:[NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: &kvoContextOfScrollView)
        
    }
    
    func updateFrameOfTableView()
    {
        let frame : CGRect = (textField!.window?.subviews[0].convert(textField!.frame, from: self.textField!.superview))!
       
        self.frame = CGRect(x: 10, y: frame.origin.y + frame.size.height, width: (UIScreen.main.bounds.size.width - 20), height: 90);
     
    }
    func showSelf()
    {
        self.isHidden = false;
    }
    
    func hideSelf()
    {
        self.isHidden = true;
    }
    
    //MARK: - TextField Delegate
    func autoTextFieldValueChanged(_ textFieldTemp: UITextField)
    {
        self.textField = textFieldTemp
        
        let frame : CGRect = (textFieldTemp.window?.subviews[0].convert(textFieldTemp.frame, from: textFieldTemp.superview))!
        
        self.frame = CGRect(x: 10, y: frame.origin.y + frame.size.height, width: (UIScreen.main.bounds.size.width - 20), height: 90);
        
        
       var currentString  = textFieldTemp.text as String!
   
        if(autoMultipleSelection.Allow == true)
        {
            
            let initialString = currentString as String!
            
            var initialStringArr = initialString?.components(separatedBy: autoMultipleSelection.separatedBy)
            
            let lastName: String? = (initialStringArr?.count)! > 0 ? initialStringArr?[(initialStringArr?.count)!-1] : initialStringArr?[0]
            
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
            
         
            
            
             let range: NSRange = (tempVale as NSString).range(of: currentString! , options: [NSString.CompareOptions.caseInsensitive])
            
            
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
    
    func autoTextFieldEditingDidBegin(_ textFieldTemp: UITextField){
        if(autoMultipleSelection.Allow == true)
        {
            
            if(self.textField?.text != nil)
            {
                
                if(self.textField?.text != "")
                {
                    let initialString = self.textField?.text as String!
                    
                    var initialStringArr = initialString?.components(separatedBy: autoMultipleSelection.separatedBy)
                    
                    var tempString : String = ""
                    
                    for( var i = 0 ; i <= (initialStringArr?.count)!-1 ; i += 1  )
                    {
                        
                        tempString += ("\(initialStringArr?[i])" + "\(autoMultipleSelection.separatedBy)")
                        
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
    func autoTextFieldEditingDidEnd(_ textFieldTemp: UITextField){
        
        if(autoMultipleSelection.Allow == true)
        {
           
            
            
            guard  let initialString = self.textField?.text as String! else
          {
            return
            }
            var initialStringArr = initialString.components(separatedBy: autoMultipleSelection.separatedBy)
            
            let lastName: String? = initialStringArr.count > 0 ? initialStringArr[initialStringArr.count-1] : initialStringArr[0]
            
            let  currentString = lastName as String!
           
            if(currentString == "")
            {
                var tempString : String = ""
                
                for( i in 0  ..< initialStringArr.count-1  )
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
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return predictionArray.count
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "autocompleteCellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        
        
    if(self.textField?.text?.characters.count>0)
    {
        if(showHighLightedText.show == true)
        {
            
            
            if(autoMultipleSelection.Allow == true)
            {
                let initialString = self.textField?.text as String!
               
                var initialStringArr = initialString?.components(separatedBy: autoMultipleSelection.separatedBy)
                
                let lastName: String? = (initialStringArr?.count)! > 0 ? initialStringArr?[(initialStringArr?.count)!-1] : initialStringArr?[0]
                
               let  currentString = lastName as String!
                
                
                cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
                
                let initialtext =   "\(predictionArray[indexPath.row])"
                
                cell?.textLabel?.textColor = showHighLightedText.normalColor
                
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialtext)
                
                let range: NSRange = (initialtext as NSString).range(of: currentString! , options: [NSString.CompareOptions.caseInsensitive])
                
                
                attrString.addAttribute(NSForegroundColorAttributeName, value: showHighLightedText.HighLightedColor, range: range)
                
                
                cell!.textLabel?.attributedText = attrString
                
                
            }
            else{
                cell?.textLabel?.text = ("\(predictionArray[indexPath.row])")
                
                let initialtext =   "\(predictionArray[indexPath.row])"
                
                cell?.textLabel?.textColor = showHighLightedText.normalColor
                
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialtext)
                
                let range: NSRange = (initialtext as NSString).range(of: (self.textField?.text!)! , options: [NSString.CompareOptions.caseInsensitive])
                
                
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
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(autoMultipleSelection.Allow == true)
        {
            var tempString : String = ""
            
            let initialString = self.textField?.text as String!
           
            var initialStringArr = initialString?.components(separatedBy: autoMultipleSelection.separatedBy)
          
            self.textField?.text = ""

            for( var i = 0 ; i <= (initialStringArr?.count)!-2 ; i += 1  )
            {
                tempString += ("\(initialStringArr?[i])" + "\(autoMultipleSelection.separatedBy)")
            }
            
            if((initialStringArr?.count)! <= autoMultipleSelection.range)
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
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
      
        return 25
    }
}
