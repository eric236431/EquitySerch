//
//  ViewController.swift
//  NewWeb_
//
//  Created by 葉書誠 on 2020/9/16.
//  Copyright © 2020 葉書誠. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController{
    
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    @IBOutlet weak var datePickerView: UIPickerView!
    @IBOutlet weak var serchBtn: UIButton!
    @IBOutlet weak var chartBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    
    var images = [UIImage]()
    
    let actionWeb = ActionWeb.share
    var dateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "集保護股權"
        actionWeb.readRealm()
        datePickerView.isHidden = true
        serchBtn.isHidden = false
        chartBtn.isHidden = false
        updateBtn.isHidden = false
        datePickerView.delegate = self
        datePickerView.dataSource = self
        
        if actionWeb.dateTable.count > 0{
            dateText.text = actionWeb.dateTable[dateIndex]
        }
        
        imageView.isHidden = true
        for i in 0...11{
            images.append(UIImage(named: "connecting_\(i)")!)
        }
        imageView.animationImages = images
        imageView.animationDuration = 1
        contentText.keyboardType = .numberPad
        contentText.placeholder = "請輸入代號"
        
        NVActivityIndicatorView(frame: activityView.bounds, type: .ballBeat, color: .black, padding: .none)
    }
    
    //查詢
    @IBAction func serch(_ sender: Any) {
//        imageView.isHidden = false
//        self.imageView.startAnimating()
        activityView.startAnimating()
        //
        actionWeb.dataContent.removeAll()
        self.actionWeb.serchAction(dateIndex: self.dateIndex, content: self.contentText.text!, mode: self.modeSwitch.isOn) { (error, dataArray) in
            if error == nil{
                self.actionWeb.dataContent = dataArray!
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoSerch", sender: sender)
                }
            }
            DispatchQueue.main.async {
//                self.imageView.stopAnimating()
//                self.imageView.isHidden = true
                self.activityView.stopAnimating()
                //
            }
        }
    }
    
    // Switch
    @IBAction func changeSwitch(_ sender: Any) {
        if modeSwitch.isOn == true{
            contentText.keyboardType = .numberPad
            contentText.placeholder = "請輸入代號"
        }else{
            contentText.keyboardType = .default
            contentText.placeholder = "請輸入名稱"
        }
    }
    
    
    //圖表
    @IBAction func chart(_ sender: Any) {
        performSegue(withIdentifier: "GoChart", sender: sender)
    }
    
    //更新
    @IBAction func update(_ sender: Any) {
        let alertController = UIAlertController(title: "更新", message: "輸入欲收尋的天數", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "請輸入天數"
            textField.keyboardType = .numberPad
        }
        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            DispatchQueue.main.async {
                self.imageView.isHidden = false
                self.imageView.startAnimating()
            }
            self.actionWeb.readRealm()
            let count = Int(alertController.textFields![0].text!)
            self.actionWeb.update(count: count!){ (success) in
                print("su",success)
                if success == true{
                    guard self.actionWeb.dateTable.count > 0 else {return}
                    DispatchQueue.main.async {
                        self.dateText.text = self.actionWeb.dateTable[0]
                    }
                }
                DispatchQueue.main.async {
                    self.imageView.stopAnimating()
                    self.imageView.isHidden = true
                }
            }
        }
        alertController.addAction(alertAction)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    //顯示 PickerView
    @IBAction func showDatePicker(_ sender: Any) {
        datePickerView.isHidden = false
        serchBtn.isHidden = true
        chartBtn.isHidden = true
        updateBtn.isHidden = true
    }
    
    
}

//MARK: -
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actionWeb.dateTable.count - 2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: actionWeb.dateTable[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateIndex = row
        dateText.text = actionWeb.dateTable[dateIndex]
    }
    
}


//MARK: -
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: -
    //手勢 單擊 關閉鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        datePickerView.isHidden = true
        serchBtn.isHidden = false
        chartBtn.isHidden = false
        updateBtn.isHidden = false
    }
}
