//
//  realm.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import Foundation
import RealmSwift

extension ActionWeb{
    
    func updateRealm(){
        let realm = try! Realm()
        
        try! realm.write{
            realm.deleteAll()
        }
        
        dateTable.sort(by:>)  //由 大到小 排序
        
        for i in 0...dateTable.count - 1 {
            let order = Order()
            let realm = try! Realm()
            order.dateData = dateTable[i]    // newDate 寫進 realm
            
            try! realm.write{
                realm.add(order)
            }
        }
    }
    
    func readRealm(){
        let realm = try! Realm()
        var datas = realm.objects(Order.self)
        datas = datas.sorted(byKeyPath: "dateData", ascending: false)
        
        dateTable.removeAll()
        for data in datas{
            dateTable.append(data.dateData)
        }
    }
   
    
}
