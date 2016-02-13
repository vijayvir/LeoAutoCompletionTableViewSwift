# LeoAutoCompletionTableViewSwift
AutoCompletionTableView in swift with several  features.
 ' Easy to Implement .
*  Auto prediction of Array Elements
*  Current Text highlighted Feature
*  Multiple Selection . 
*  Multiple selection sepratated by  (default by ',')
*  Compatile with Scroll view feature (Here it scroll with Textfield)
*  Smart work Auto removal and additions of Seprated by (default ",") on textField Edit and End Editing 

And here's some code! :+1: with example 

```javascript
   lazy  var autoCompleteTVFruitNames : AutoCompleteTableView = self.initAutoCompleteTableView(self.fruitNameTF ,array: self.fritNameArr)
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
        auto.autoMultipleSelection.Allow = true
        auto.autoMultipleSelection.range = 2
    
        
    return auto
    
    }
    // In View Did Load Method 
    fritNameArr += [ "Apple"," Apricot"," Avocado","Banana","ilberry","Blackberry","Blackcurrant", "Blueberry", "Boysenberry", "Cantaloupe"," cucumber"," Currant"," Cherry"," Cherimoya"," Cloudberry"," Coconut", "Cranberry"," Damson", "Date"," Dragonfruit", "Durian","Elderberry","Feijoa","Fig", "Goji ber"]
    
    
        // Make sure .. call this Line of code .. as this allocate memory to Auto Completion Class.
         animalNamesTF.addTarget(self.autoCompleteTVAnimalsNames, action: "autoTextFieldValueChanged:", forControlEvents: UIControlEvents.EditingChanged)
    
    //MARK: -  AutoCompleteTableView Delegate
    
    @objc   func  autoCompleteTableView(tableView: AutoCompleteTableView, didAddItem: String) -> Array<String>
    {
        
        return fritNameArr
    }
    @objc   func  autoCompleteTableView(tableView: AutoCompleteTableView, textField: String , rangeExceed: Bool)
    {
        
      print("Please Check Range ")
    }
```
