//
//  ActionWeb.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import UIKit
import RealmSwift
import Kanna
import SVProgressHUD

class ActionWeb: NSObject {
    
    static let share = ActionWeb()
    var myDate = Date()
    var dateTable = [String]()
    
    var dataContent = [[dataStruct]]()
    
    var webNumber = ""
    var webTitle = ""
    var webDate = ""
    
    struct dataStruct {
        var level : String?
        var count : String?
        var have : String?
        var proportion : String?
    }
}


extension ActionWeb{
    func dateFormatter(date: Date) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        
        
        return dateFormatter.string(from: date)
    }
}
