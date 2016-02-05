//
//  ViewController.swift
//  AutoCompleteTableViewDemo
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 Vijayvir. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,AutoCompleteTableViewDelegate {

    //MARK: Properties
    
    @IBOutlet weak var fruitNameTF: UITextField!
    
    @IBOutlet weak var animalNamesTF: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var fritNameArr : [String] = []
    
    lazy  var autoCompleteTVFruitNames : AutoCompleteTableView = self.initAutoCompleteTableView(self.fruitNameTF ,array: self.fritNameArr)
    lazy  var autoCompleteTVAnimalsNames : AutoCompleteTableView = self.initAutoCompleteTableView(self.animalNamesTF,array: self.fritNameArr)
    
    func initAutoCompleteTableView(textField: UITextField , array : Array<String>) -> AutoCompleteTableView
    {
        
        let auto : AutoCompleteTableView  = AutoCompleteTableView(textfield: textField, tfFrame: self.view.convertRect(textField.frame, fromView: textField.superview), parentViewController: self)
            auto.predictionArray = array
        auto.layer.borderColor = UIColor.grayColor().CGColor
        auto.layer.borderWidth = 2.0;
        auto.layer.cornerRadius = 12.0;
        auto.autoCompleteTableViewDelegate = self;
        auto.setScrollView(self.scrollView)
        auto.showHighLightedText = (true,UIColor.redColor(), UIColor.grayColor())
        auto.autoMultipleSelection=(true,",")
  
        
    return auto
  
    }
      //MARK: CLC: Class Life Cycle 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      fritNameArr += [ "Apple"," Apricot"," Avocado","Banana","ilberry","Blackberry","Blackcurrant", "Blueberry", "Boysenberry", "Cantaloupe"," cucumber"," Currant"," Cherry"," Cherimoya"," Cloudberry"," Coconut", "Cranberry"," Damson", "Date"," Dragonfruit", "Durian","Elderberry","Feijoa","Fig", "Goji ber"]
    
    
        // set observer on textField in tableviewClass
        fruitNameTF.addTarget(self.autoCompleteTVFruitNames, action: "autoTextFieldValueChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
       
            
         animalNamesTF.addTarget(self.autoCompleteTVAnimalsNames, action: "textFieldValueChanged:", forControlEvents: UIControlEvents.EditingChanged)
   
    }

    override  func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //MARK : Auto Completion 
    
   
    //MARK: Textfield Delegate
     func textFieldShouldReturn(textField: UITextField) -> Bool
     {
        textField.resignFirstResponder()
        
        return true
      }
    
    
    //MARK: -  AutoCompleteTableView Delegate
    
  @objc   func  autoCompleteTableView(tableView: AutoCompleteTableView, didAddItem: String) -> Array<String>
    {
        
        return fritNameArr
    }
    
}

