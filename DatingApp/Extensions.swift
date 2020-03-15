import Foundation
import UIKit

@IBDesignable class PaddingLB: UILabel {
    
    @IBInspectable var topInset: CGFloat        = 5.0
    @IBInspectable var bottomInset: CGFloat     = 5.0
    @IBInspectable var leftInset: CGFloat       = 10.0
    @IBInspectable var rightInset: CGFloat      = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

extension UILabel{
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


extension UITextField {
    
    func setBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(red: 197/255, green: 191/255, blue: 188/255, alpha: 1.0).cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    func setWithTextBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    func setColorBottomBorder() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(red: 288/255, green: 181/255, blue: 199/255, alpha: 1.0).cgColor
        layer.addSublayer(bottomBorder)
        
        // self.borderStyle = .none
        // self.layer.backgroundColor = UIColor.white.cgColor
        // self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.gray.cgColor
        // self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        // self.layer.shadowOpacity = 1.0
        // self.layer.shadowRadius = 0.0
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}

extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}



extension UITextView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


