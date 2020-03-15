//
//  faq.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 15/12/19.
//  Copyright © 2019 AJ. All rights reserved.
//

import Foundation

class faq{
    
    var answer:String = ""
    var question:String = ""
    var id:String = ""
    
    
    class func faqDetailSaved(data:[String:Any]) -> faq{
        
        let faqDetail = faq()
        faqDetail.id = (data["id"] as? String)!
        faqDetail.question = (data["question"] as? String)!
        faqDetail.answer = (data["answer"] as? String)!
        
        return faqDetail
    }
    
}
