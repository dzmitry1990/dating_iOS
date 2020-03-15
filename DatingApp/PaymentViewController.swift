
import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate,hideMenu {
   
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var paypalView: UIView!
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var masterCardBtn: UIButton!
    @IBOutlet var visaBtn: UIButton!
    @IBOutlet var amexBtn: UIButton!
    @IBOutlet var paypalBtn: UIButton!
    
    var yearmonthDatePicker = UIDatePicker()
    
    @IBOutlet var nameTxtField: TextField!
    @IBOutlet var creditCardTxtField: TextField!
    @IBOutlet var expiryDateTxtField: TextField!
    @IBOutlet var cvcTxtField: UITextField!
    
    @IBOutlet var cardImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        yearmonthDatePicker.datePickerMode = UIDatePickerMode.date
        expiryDateTxtField.inputView = yearmonthDatePicker
        yearmonthDatePicker.addTarget(self, action: #selector(PaymentViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        yearmonthDatePicker.minimumDate = NSDate() as Date
        
    }
    
    //MARK:
    //MARK: - INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = paypalView.frame.origin.y + paypalView.frame.size.height + 20
    }
    
    //MARK:
    //MARK: - IBACTIONS
    @IBAction func masterCardBtnPressed(_ sender: Any) {
        cardImg.image = UIImage(named: "master card")
        masterCardBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        visaBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        amexBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        paypalBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        
    }
    @IBAction func visaBtnPressed(_ sender: Any) {
        cardImg.image = UIImage(named: "visa")
        visaBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        masterCardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        amexBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        paypalBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
    }
    
    @IBAction func amexBtnPressed(_ sender: Any) {
        cardImg.image = UIImage(named: "amex")
        amexBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        masterCardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        visaBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        paypalBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
    }
    @IBAction func paypalBtnPressed(_ sender: Any) {
        cardImg.image = UIImage(named: "")
        paypalBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        masterCardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        visaBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        amexBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        menuBtn.isEnabled = false
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.hideMenus = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    func hide() {
        menuBtn.isEnabled = true
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    
    //MARK:
    //MARK:- DATEPICKER METHODS
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "MM/yyyy"
        
        expiryDateTxtField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    //MARK:
    //MARK:- TEXTFIELD METHODS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == creditCardTxtField){
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else if (textField == cvcTxtField){
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
}
