//
//  ViewController.swift
//  AKMonthYearPickerViewExample
//
//  Created by Ali Khan on 7/17/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAKMonthYearPickerAction(_ sender: Any) {
        AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0.05882352941, green: 0.6980392157, blue: 0.6784313725, alpha: 1)

        AKMonthYearPickerView.sharedInstance.previousYear = 4
        
        AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
    }
    
    private func doneHandler() {
        print("Month picker Done button action")
    }
    
    private func completetionalHandler(month: Int, year: Int) {
        print( "month = ", month, " year = ", year )
    }
}

