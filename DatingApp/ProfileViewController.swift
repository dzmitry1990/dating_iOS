
import UIKit
import Koloda
import SDWebImage
import StoreKit

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class ProfileViewController: UIViewController,hideMenu {
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var profileNameLbl: UILabel!
    @IBOutlet var profileAgeLbl: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var swipeCount:Int = 0
    var profilesArr:[Profiles] = []
    var backSubcription:Bool = false
    var sendMessageSubcription:Bool = false
    
    var imagesArr = [UIImage(named:"girl_image"),UIImage(named:"perfect"),UIImage(named:"girl_image"),UIImage(named:"perfect"),UIImage(named:"girl_image")]
    
    @IBOutlet var noTextFound: UILabel!
    
    var receiptRefreshRequest: SKRequest = SKReceiptRefreshRequest()
    
    @IBOutlet var guide1Btn: UIButton!
    @IBOutlet var guide2Btn: UIButton!
    @IBOutlet var guideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //receiptRefreshRequest.delegate = self
        //receiptRefreshRequest.start()
        
        //HIDE NAVIGATION BAR
        self.navigationController?.isNavigationBarHidden = true
        
        //SET KOLODA ANIMATION
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        
        //CALL USERGET RESULT API
        kolodaView.isHidden = true
        
        //Chat Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadviewforchat), name: NSNotification.Name(rawValue: "loadviewforchat"), object: nil)
        
        //Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadviewfornotifications), name: NSNotification.Name(rawValue: "loadviewfornotifications"), object: nil)
        
       // restore()
//        if let value = UserDefaults.standard.value(forKey: "Guild") as? String{
//            self.guideView.isHidden = false
//            self.guide1Btn.isHidden = false
//            self.guide2Btn.isHidden = true
//            UserDefaults.standard.setValue(nil, forKey: "Guild")
//        }
//        else {
//            self.guideView.isHidden = true
//        }
        
    }
    
    public func requestDidFinish(request: SKRequest) {
        if request == receiptRefreshRequest {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
        }
    }
    
    func restore() {
        //SKPaymentQueue.default().add(self)
        //RageProducts.store.restorePurchases()
        if (SKPaymentQueue.canMakePayments()) {
            RageProducts.store.restorePurchases()
        }
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swipeCount = 0
        menuBtn.isEnabled = true
        
//        if (appDelegate.swipeItems.count > 0){
//            profilesArr = appDelegate.swipeItems
//            kolodaView.isHidden = false
//        }
//        else {
            kolodaView.isHidden = true
            getUsersProfiles()
       // }
        
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            let backWard = userInfo["backWardSubscription"] as? String
            let message = userInfo["messageSubscription"] as? String
            let backWardExpireDate = userInfo["backWardSubscriptionExpireDate"] as? String
            let messageExpireDate = userInfo["messageSubscriptionExpireDate"] as? String
            
            if (backWard == "25"){
                let prvDateDoubleVal = Double(backWardExpireDate!)
                let currentDate = NSDate()
                let Prevoiusdate =  NSDate(timeIntervalSince1970: prvDateDoubleVal!)
                
                switch Prevoiusdate.compare(currentDate as Date) {
                case .orderedAscending:
                    self.backSubcription = false
                    break
                case .orderedSame:
                    self.backSubcription = true
                    break
                case .orderedDescending:
                    self.backSubcription = true
                    break
                }
            }
            else {
                self.backSubcription = false
            }
            
            if (message != "" && message != nil){
                
                let prvDateDoubleVal = Double(messageExpireDate!)
                let currentDate = NSDate()
                let Prevoiusdate =  NSDate(timeIntervalSince1970: prvDateDoubleVal!)
                
                switch Prevoiusdate.compare(currentDate as Date) {
                case .orderedAscending:
                    self.sendMessageSubcription = false
                    break
                case .orderedSame:
                    self.sendMessageSubcription = true
                    break
                case .orderedDescending:
                    self.sendMessageSubcription = true
                    break
                }
            }
            else {
                self.sendMessageSubcription = false
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //appDelegate.swipeItems = profilesArr
        profilesArr = []
        noTextFound.text == ""
    }
    
    //MARK:-  CHAT NOTIFICATION HANDLER
    func loadviewforchat(_ notification: Notification) {
        let userInfo = notification.object as? [AnyHashable: Any]
        print(userInfo)
        let body = userInfo!["body"] as? [String:Any]
        let friendId = body!["sender_id"] as? String
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        let notificationDetail = userInfo!["body"] as? [String:Any]
        let itemDetail = notificationDetail!["Notification"] as? [String:Any]
        nextViewController.friendID = friendId
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK:- PAYMENT NOTIFICATIONS HANDLER
    func loadviewfornotifications(_ notification: Notification) {
        let userInfo = notification.object as? [AnyHashable: Any]
        print(userInfo)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyMessagesViewController") as! ReplyMessagesViewController
        //let notificationDetail = userInfo!["body"] as? [String:Any]
       // let itemDetail = notificationDetail!["Notification"] as? [String:Any]
       // nextViewController.order_id = (itemDetail!["order_id"] as? String)!
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        //Utilities.goBack(controller: self)
      
        if (backSubcription == true){
            kolodaView?.revertAction()
        }
        else {
            alertView()
        }
    }
    
    @IBAction func sendMessageBtnPressed(_ sender: Any) {
        
        if (sendMessageSubcription == true){
        
        
            if (profilesArr.count > 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            let currentIndex = kolodaView.currentCardIndex
            let value = profilesArr[currentIndex]
            nextViewController.friendID = value.id
            self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        else {
            alertView()
        }
    }

    
    @IBAction func openMenuBtnPressed(_ sender: Any)
    {
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
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyMessagesViewController") as! ReplyMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    @IBAction func downBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.down)
    }
    
    @IBAction func PerfectBtnPressed(_ sender: Any) {
        kolodaView?.swipe(.up)
    }
    
    @IBAction func doubleHeartPressed(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    @IBAction func guide1BtnPressed(_ sender: Any) {
        guide1Btn.isHidden = true
        guide2Btn.isHidden = false
    }
    
    @IBAction func guide2BtnPressed(_ sender: Any) {
        guideView.isHidden = true
    }
    
    //MARK: - FUNCTIONS
    func getUsersProfiles(){
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                let seeking = userInfo["seeking"] as? String
                
                var gender = ""
                if let genderVal = seeking{
                    gender = genderVal
                }
                else {
                    gender = "1"
                }
                
                ApIManager.sharedInstance.getProfileApi(gender: gender, completion: { (userProfiles,error,success) in
                    Utilities.hideProgressView(view: self.view)
                    if (success){
                        if (userProfiles.count == 0){
                            self.noTextFound.text = "No User Found"
                            //Utilities.alertView(controller: self, title: "", msg: "No User found")
                        }
                        else {
                            self.noTextFound.text = ""
                            self.profilesArr = userProfiles
                            self.kolodaView.isHidden = false
                            self.kolodaView.reloadData()
                          
                        }
                    }
                    else {
                       Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                })
                
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    func callLikesApi(userInfoDict:[String:Any]){
        
        DispatchQueue.global(qos: .background).async {
            ApIManager.sharedInstance.userLikeStatusApi(userInfo: userInfoDict, completion: { (success) in
                if (success){
                    DispatchQueue.main.async{
                        if (self.profilesArr.count == self.swipeCount){
                            self.swipeCount = 0
                            self.reloadProfiles()
                        }
                    }
                    print("success")
                }
                else {
                    print("failure")
                }
            })
        }
        
    }
    
    func reloadProfiles(){
        
        if (Reachability.isConnectedToNetwork()){
            self.kolodaView.isHidden = true
            getUsersProfiles()
        }
        else{
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    func hide(){
        menuBtn.isEnabled = true
    }
    
    func alertView(){
        // create the alert
        let alert = UIAlertController(title: "Subscription", message: "Please Purchase Subscription", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { (action: UIAlertAction!) in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: KolodaViewDelegate
extension ProfileViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        if (profilesArr.count > 0){
            let userDown = profilesArr[index]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            nextViewController.id = userDown.id
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool{
        return true
    }
    
    //    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
    //        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    //        animation?.springBounciness = frameAnimationSpringBounciness
    //        animation?.springSpeed = frameAnimationSpringSpeed
    //        return animation
    //    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .down:
            
            var userInfo:[String:Any] = [:]
            if (profilesArr.count > 0){
                swipeCount += 1
                let userDown = profilesArr[index]
                userInfo = ["friend_id":userDown.id,"type":"2"]
                print(userInfo)
            }
            callLikesApi(userInfoDict: userInfo)
            
            break
        case .up:
            
            var userInfo:[String:Any] = [:]
            if (profilesArr.count > 0){
                swipeCount += 1
                let userUp = profilesArr[index]
                userInfo = ["friend_id":userUp.id,"type":"1"]
                print(userInfo)
            }
            callLikesApi(userInfoDict: userInfo)
            
            break
            
        case .right:
//            var userInfo:[String:Any] = [:]
//            if (profilesArr.count > 0){
//                swipeCount += 1
//                let userUp = profilesArr[index]
//                userInfo = ["friend_id":userUp.id,"type":"3"]
//                print(userInfo)
//            }
//            callLikesApi(userInfoDict: userInfo)
            
            break
        default:
            break
        }
    }
}

// MARK: KolodaViewDataSource
extension ProfileViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return profilesArr.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        if (profilesArr.count > 0){
            
            let value = profilesArr[index]
            
            if let imageUrl = value.photo as? String{
                self.profileImgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholderImg"))
            }
            
            if let firstNam = value.name as? String{
                self.profileNameLbl.text = value.name.capitalized
            }
            
            
            if let age = value.birthday as? String{
                self.profileAgeLbl.text = age
            }
        }
        
        return mainView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

