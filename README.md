# LeoAutoCompletionTableViewSwift
AutoCompletionTableView in swift with several  features.


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
