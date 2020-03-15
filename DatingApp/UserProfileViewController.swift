
import UIKit
import MessageUI

class UserProfileViewController: UIViewController,MFMailComposeViewControllerDelegate {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var maleBtn: UIButton!
    @IBOutlet var femaleBtn: UIButton!
    @IBOutlet var maleSeekingBtn: UIButton!
    @IBOutlet var femaleSeekingBtb: UIButton!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var skinTextField: UITextField!
    @IBOutlet var eyesTextField: UITextField!
    @IBOutlet var childrenYesBtn: UIButton!
    @IBOutlet var childrenNoBtn: UIButton!
    @IBOutlet var howManyTextField: UITextField!
    @IBOutlet var religionTextField: UITextField!
    @IBOutlet var aboutUsTextField: UITextView!
    var id = ""
    
    @IBOutlet var blockView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfileInfo()
    }
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = submitBtn.frame.origin.y + submitBtn.frame.size.height + 30
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func blockViewBtnPressed(_ sender: Any) {
        
        if (blockView.isHidden == true){
            blockView.isHidden = false
        }
        else {
            blockView.isHidden = true
        }
    }
    @IBAction func reportBtnPressed(_ sender: Any) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["Mydate@my.com"])
        composeVC.setSubject("Report User")
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    //MARK: -DISSMIS CONTROLLER
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blockBtnPressed(_ sender: Any) {
        
        let dic:[String:Any] = ["friend_id":id]
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.blockUser(userInfo: dic, completion: { (error,success) in
                 Utilities.hideProgressView(view: self.view)
                if (success){
                    if (error == "Block User successfully"){
                        Utilities.toasterView(msg: error)
                        Utilities.goBack(controller: self)
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                }
                else {
                     Utilities.alertView(controller: self, title: "Try Again", msg: "Server Not Working")
                }
            })
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    func showUserInfo(dict:[String:Any]){
        
        profileImgView.sd_setImage(with: URL(string:(dict["photo"] as? String)!), placeholderImage: UIImage(named: "placeholderImg"))
        firstNameTextField.text = dict["first_name"] as? String
        lastNameTextField.text = dict["last_name"] as? String
        ageTextField.text = dict["birthday"] as? String
        cityTextField.text = dict["city"] as? String
        stateTextField.text = dict["state"] as? String
        countryTextField.text = dict["country"] as? String
        let gender = dict["gender"] as? String
        if (gender == "1"){
            maleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        else {
            femaleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        
        let seeking = dict["seeking"] as? String
        if (seeking == "1"){
            maleSeekingBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        else {
            femaleSeekingBtb.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        
        heightTextField.text = dict["height"] as? String
        weightTextField.text = dict["wight"] as? String
        skinTextField.text = dict["skin"] as? String
        eyesTextField.text = dict["eyes"] as? String
        
        let children = dict["children"] as? String
        if (children == "0"){
            childrenNoBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        else {
            howManyTextField.text = children
            childrenYesBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        religionTextField.text = dict["religion"] as? String
        aboutUsTextField.text = dict["comment"] as? String
        
        
    }
    
    func getUserProfileInfo(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getUserProfile(id: id,auth_key: Authorization_key, completion: { (error,userInfo, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (error == ""){
                        print(userInfo)
                        self.showUserInfo(dict: userInfo)
                    }
                    else {
                       Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                }
                else {
                    Utilities.alertView(controller: self, title: "Try Again", msg: "Server Not Working")
                }
            })
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
        
        
    }
}
