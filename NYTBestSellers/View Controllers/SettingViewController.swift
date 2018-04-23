//
//  SettingViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/2/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var category = [Category]() {
        didSet {
            self.pickerView.reloadAllComponents()
            if let defaultRow = UserDefaults.standard.value(forKey: "default category") as? Int {
                self.pickerView.selectRow(defaultRow, inComponent: 0, animated: true)
                self.pickerView.reloadComponent(0)
            }
        }
    }
      let key = "29ca5ca3f7894a91826d750e77fcb227"
  
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        loadCategory()

    }
    

    
    func loadCategory() {
        CategoryAPIClient.manager.getCategory(from: key, completionHandler: {self.category = $0}, errorHandler: {print($0)})
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row].list_name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "default category")
        
    }

   
    


}
