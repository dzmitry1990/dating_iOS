//
//  Countrys.swift
//  Mydate
//
//  Created by Dzmitry Zhuk on 29/01/18.
//  Copyright © 2018 AJ. All rights reserved.
//

import Foundation

class Countrys{
    
    var country_id:String?
    var country_name:String?
    var states:[States] = []
    class func CountrysDetailSaved(data:[String:Any]) -> Countrys{
        
        let CountrysDetail = Countrys()
        CountrysDetail.country_id = data["Country_id"] as? String
        CountrysDetail.country_name = data["Country_name"] as? String
        
        if let states = data["States"] as? [[String:Any]]{
            
            for statesVal in states{
                let value = States.StatesDetailSaved(data: statesVal)
                CountrysDetail.states.append(value)
            }
        }
        
        return CountrysDetail
    }
    
}

class States{
    
    var country_id:String?
    var state_name:String?
    var id:String?
    
    class func StatesDetailSaved(data:[String:Any]) -> States{
        
        let StatesDetail = States()
        StatesDetail.country_id = data["country_id"] as? String
        StatesDetail.state_name = data["name"] as? String
        StatesDetail.id = data["id"] as? String
        return StatesDetail
    }
    
}
