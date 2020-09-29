//
//  action.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import Foundation

extension ActionWeb{
    
    //MARK: - 查詢
    func serchAction(dateIndex: Int, content: String, mode: Bool, success: @escaping(Error?, [[dataStruct]]?) -> Void){
        guard dateTable.count > 1 else {return}
        var dataArray = [[dataStruct]]()
        var body = bodyMake(date: dateTable[dateIndex], content: content, mode: mode)
        postAction(body: body) { (error, html) in
            if error == nil{
                dataArray.append(self.KannaData(data: html!, isFirst: true)!)
                body = self.bodyMake(date: self.dateTable[dateIndex + 1], content: content, mode: mode)
                
                self.postAction(body: body) { (error2, html2) in
                    if error2 == nil{
                        dataArray.append(self.KannaData(data: html2!, isFirst: false)!)
                        success(nil, dataArray)
                    }else{
                        success(error2,nil)
                    }
                }
            }else{
                success(error,nil)
            }
        }
    }
    
    //MARK: - 更新
    func update(count: Int, success: @escaping(_ success: Bool) -> Void){
        print("x",count)
        guard count > 0 else {
            success(true)
            return
        }
        var progress = count
        let newDate = dateFormatter(date: myDate)
        
        if dateTable.contains(newDate) == true{
            
            progress -= 1
            self.myDate -= 60*60*24
            self.update(count: progress) { (bool) in
                if bool == true{
                    success(true)
                }
            }
            
        }else{
            
            let body = bodyMake(date: newDate, content: "2603", mode: true)
            postAction(body: body) { (error, html) in
                let dataStruct = self.KannaData(data: html!, isFirst: false)
                if dataStruct!.count > 5{
                    progress -= 1
                    print(count)
                    self.dateTable.append(newDate)
                    self.updateRealm()
                }
                self.myDate -= 60*60*24
                self.update(count: progress) { (bool) in
                    if bool == true{
                        success(true)
                    }
                }
            }
            
        }
    }
    

}

