//
//  SerchViewController.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/21.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import UIKit

class SerchViewController: UIViewController {
    
    @IBOutlet weak var webTitle: UILabel!
    @IBOutlet weak var webNumber: UILabel!
    @IBOutlet weak var webDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let actionWeb = ActionWeb.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查詢"
        tableView.rowHeight = 40
        webTitle.text = actionWeb.webTitle
        webNumber.text = actionWeb.webNumber
        webDate.text = actionWeb.webDate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

}

extension SerchViewController{
    func calculation(first: String, second: String) -> Double{
        var newFisrt = ""
        var newSecond = ""
        
        for i in first{
            if i != ","{newFisrt = newFisrt + String(i)}
        }
        
        for i in second{
            if i != ","{newSecond = newSecond + String(i)}
        }
        
        let math = Double(newFisrt)! - Double(newSecond)!
        return math
    }
    
    func stringFormatter(math: Double) -> String{
        //原始值
        let number = NSNumber(value: math)
         
        //创建一个NumberFormatter对象
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,###.##" //设置格式
        //格式化
        let format = numberFormatter.string(from: number)!
        return "(\(format))"
    }
}

extension SerchViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionWeb.dataContent[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! SerchTableViewCell
        cell.level.text = actionWeb.dataContent[0][indexPath.row].level
        cell.have.text = actionWeb.dataContent[0][indexPath.row].have
        cell.count.text = actionWeb.dataContent[0][indexPath.row].count
        cell.proportion.text = actionWeb.dataContent[0][indexPath.row].proportion
        
        if indexPath.row == 0{
            cell.lastProportion.text = ""
            cell.lastHave.text = ""
            cell.lastCount.text = ""
            return cell
        }
        
        let mathHave = calculation(first: actionWeb.dataContent[0][indexPath.row].have!, second: actionWeb.dataContent[1][indexPath.row].have!)
        if mathHave < 0 {
            cell.lastHave.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else{
            cell.lastHave.textColor = #colorLiteral(red: 0.7664813995, green: 0.05388415605, blue: 0.1382417381, alpha: 1)
        }
        cell.lastHave.text = stringFormatter(math: mathHave)
        
        
        
        let mathCount = calculation(first: actionWeb.dataContent[0][indexPath.row].count!, second: actionWeb.dataContent[1][indexPath.row].count!)
        if mathHave < 0 {
            cell.lastCount.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else{
            cell.lastCount.textColor = #colorLiteral(red: 0.7664813995, green: 0.05388415605, blue: 0.1382417381, alpha: 1)
        }
        cell.lastCount.text = stringFormatter(math: mathCount)
        
        
        
        let mathProportion = calculation(first: actionWeb.dataContent[0][indexPath.row].proportion!, second: actionWeb.dataContent[1][indexPath.row].proportion!)
        if mathHave < 0 {
            cell.lastProportion.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else{
            cell.lastProportion.textColor = #colorLiteral(red: 0.7664813995, green: 0.05388415605, blue: 0.1382417381, alpha: 1)
        }
        cell.lastProportion.text = stringFormatter(math: mathProportion)
        
        return cell
    }
    
}
