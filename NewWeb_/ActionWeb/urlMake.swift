//
//  urlMake.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import Foundation

extension ActionWeb{
    
    func bodyMake(date: String, content: String, mode: Bool) -> String{
    
        var body = ""
        
        if mode == true{
            body = "scaDates=\(date)&scaDate=\(date)&SqlMethod=StockNo&StockNo=&radioStockNo=\(content)&StockName=&REQ_OPR=SELECT&clkStockNo=\(content)&clkStockName="
        }else{
            let newName = big5String(content)
            body = "scaDates=\(date)&scaDate=\(date)&StockNo=&SqlMethod=StockName&StockName=\(newName)&radioStockName=\(newName)&REQ_OPR=SELECT&clkStockNo=&clkStockName=\(newName)"
        }
        
        return body
        
    }
    
    //MARK: - 轉 url需要用的格式
    func big5String(_ serchcontent:String) -> String {
        var count = 0
        var newContent3 = ""
        var bool = false
        
        let newContent2 = (serchcontent.big5Data)!.description
        
        for i in newContent2 {
            if bool == false{
                if i != "x"{
                    count = count + 1
                }else{
                    count = count + 1
                    bool = true
                }
            }else{
                if i != "}" {
                    newContent3 = newContent3 + String(i)
                }
            }
            
        }
        print(newContent3)
        var newContent = "%"
        var cut = 1
        for i in newContent3 {
            if cut < 2 {
                newContent = newContent + String(i)
                cut = cut + 1
            }else{
                newContent = newContent + String(i) + "%"
                cut = 1
            }
        }
        newContent = (newContent as NSString).substring(to: newContent.count - 1)
        return newContent
    }
    
}

//MARK: - 轉 big5 編碼
extension String {
    var big5Data : NSData? {
        let big5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue))
        return self.data(using: String.Encoding(rawValue: big5), allowLossyConversion: false) as NSData?;
    }
}
