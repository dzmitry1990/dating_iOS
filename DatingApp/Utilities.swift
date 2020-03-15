
import Foundation
import UIKit
import MBProgressHUD
import Toaster

class Utilities{
    
    //alert View
    class func alertView(controller:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    //goBackController
    class func goBack(controller:UIViewController){
        controller.navigationController?.popViewController(animated: true)
    }
    
    
    //goBackRootController
    class func goBackRoot(controller:UIViewController){
        controller.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //show progress
    class func showProgressView(view:UIView){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    //hide progress
    class func hideProgressView(view:UIView){
        MBProgressHUD.hide(for:view,animated:true)
    }
    
    
    class func addNavigationTitleImage(controller:UIViewController){
        let logo = UIImage(named: "dora-icon")
        let imageView = UIImageView(image:logo)
        controller.navigationItem.titleView = imageView
    }
    
    //show Toast Msg
    class func toasterView(msg:String){
        ToastView.appearance().backgroundColor = UIColor(red: 255/255, green: 111/255, blue: 165/255, alpha: 1.0)
        ToastView.appearance().tintColor = UIColor.red
        let toast = Toast(text: msg)
        
        toast.show()
    }
    
    
    class func itemRating(num:Int) -> UIImage{
        
        switch num {
        case 1:
            return UIImage(named: "step_1")!
        case 2:
            return UIImage(named: "step_2")!
        case 3:
            return UIImage(named: "step_3")!
        case 4:
            return UIImage(named: "step_4")!
        case 5:
            return UIImage(named: "step_5")!
        default:
            return UIImage(named: "")!
        }
        
    }
    
    class func getUserID() -> AnyObject {
        
        let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]
        return  userInfo!["id"] as AnyObject
    }
    
    
}

//MARK: - CUSTOM ClASS'S

// Increase Slider height
class CustomUISlider : UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = 10 //added height for desired effect
        return result
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func buttomLine() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomBorder)
    }
    
}

@IBDesignable class BigSwitch: UISwitch {
    
    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
    
    
}


