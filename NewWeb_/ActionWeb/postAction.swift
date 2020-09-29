//
//  postAction.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kanna
import SVProgressHUD

extension ActionWeb {
    //MARK: - 呼叫 API
    func postAction( body : String, success: @escaping(Error?, String?) -> Void)  {
        guard let serviceUrl = URL(string: "https://www.tdcc.com.tw/smWeb/QryStockAjax.do") else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = .infinity
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let cfEnc = CFStringEncodings.big5
                let nsEnc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                let big5encoding = String.Encoding(rawValue: nsEnc)
                let value = String(data: data, encoding: big5encoding)
                
                success(nil,value)
            }else{
                success(error,nil)
            }
            
        }.resume()
        
    }
    
    //MARK: - Kanna 解析
    func KannaData(data: String, isFirst: Bool) -> [dataStruct]? {
        var dataStcs = [dataStruct]()
        var dataStc = dataStruct(level: nil, count: nil, have: nil, proportion: nil)
        
        if let doc = try? HTML(html: data, encoding: .utf8) {
            webTitle = doc.title!
            var count = 0
            for link in doc.css("table") {
                if count == 6 {
                    var i = 1
                    for link2 in link.css("td"){
                        switch i {
                        case 1:
                            if isFirst == true {
                                webNumber = link2.text!
                            }
                            i = i + 1
                            break
                        case 2:
                            if isFirst == true {
                                webDate = link2.text!
                            }
                            i = i + 1
                            break
                        default:break
                        }
                    }
                }else if count == 7  {
                    
                    var f = 0
                    var j = 1
                    var k = 0
                    for link2 in link.css("td"){
                        if  k != 0 {
                            
                            switch f {
                            case 0:
                                dataStc.level = link2.text
                                f = f + 1
                                break
                            case 1:
                                dataStc.count = link2.text
                                f = f + 1
                                break
                            case 2:
                                dataStc.have = link2.text
                                f = f + 1
                                break
                            case 3:
                                dataStc.proportion = link2.text
                                f = 0
                                j = j + 1
                                break
                            default: break
                            }
                            k = k + 1
                            if k == 5 {
                                dataStcs.append(dataStc)
                                dataStc = dataStruct(level: nil, count: nil, have: nil, proportion: nil)
                                k = 0
                            }
                        }else{
                            k = k + 1
                        }
                        
                    }
                }
                
                count = count + 1
            }
        }
        return dataStcs
    }
    
}

