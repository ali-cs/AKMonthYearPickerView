//
//  AKMonthYearPickerView.swift
//  AUXO
//
//  Created by Ali Khan on 11/Jul/18.
//  Copyright © 2018 Telenor. All rights reserved.
//

/*
    AKMonthYearPickerView is a lightweight, clean and easy-to-use Month picker control in iOS written in Swift language.
    https://github.com/ali-cs/AKMonthYearPickerView
 */

import Foundation
import UIKit

struct AKMonthYearPickerConstants {
    
    struct AppFrameSettings {
        
        static var screenHeight : CGFloat {
            return UIScreen.main.bounds.size.height
        }
        
        static var screenWidth : CGFloat {
            return UIScreen.main.bounds.size.width
        }
    }
}

class AKMonthYearPickerView: UIView {
    
    //MARK:- Variables
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var onDoneButtonSelected: (() -> Void)?
    
    private var monthYearPickerView : MonthYearPickerView?
    var barTintColor                = UIColor.blue
    var previousYear                = 2
    
    static var sharedInstance   = {
        return AKMonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216)))
    }()
    
    var toolBar : UIToolbar?
    
    //MARK:- Inilizers
    
    convenience init() {
        let frame = CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216))
        
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.white
        
        layer.borderColor   = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
        
        layer.borderWidth   = 1.0
        layer.cornerRadius  = 7.0
        layer.masksToBounds = true
        
        monthYearPickerView = MonthYearPickerView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+40, width: frame.size.width, height: frame.size.height))
        monthYearPickerView?.previousYear = previousYear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Helper Mehtods
    
    func show(vc: UIViewController, doneHandler: @escaping () -> (), completetionalHandler: @escaping (Int, Int) -> () ) {
        monthYearPickerView?.previousYear = previousYear
        
        monthYearPickerView?.onDateSelected = completetionalHandler
        onDoneButtonSelected = doneHandler
        
        if let doneToolBar = toolBar {
            vc.view.addSubview(doneToolBar)
        }
        else {
            toolBar = getToolBar()
            vc.view.addSubview(toolBar!)
        }
        
        vc.view.addSubview(monthYearPickerView!)
        
        toolBar?.isHidden             = false
        monthYearPickerView?.isHidden = false
    }
    
    func hide() {
        monthYearPickerView?.hide()
        
        AKMonthYearPickerView.sharedInstance.removeFromSuperview()
        toolBar?.isHidden = true
        self.isHidden     = true
    }
    
    func getToolBar() -> UIToolbar {
        
        let customToolbar          = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 40)))
        
        customToolbar.barStyle     = .blackTranslucent
        customToolbar.barTintColor = barTintColor
        customToolbar.tintColor    = UIColor.white
        
        embedButtons(customToolbar)
        return customToolbar
    }
    
    private func embedButtons(_ toolbar: UIToolbar) {
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed(_:)))
        
        toolbar.setItems([ flexButton, flexButton, flexButton, doneButton], animated: true)
    }
    
    @objc func donePressed(_ sender: Any) {
        onDoneButtonSelected?()
        hide()
    }
}

/// This class is responsible for handling the pickerView delegate and datasource
private class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- Variables
    
    var months          : [String]!
    var years           : [Int]!
    var previousYear    = 2
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    static var sharedInstance   = {
        return MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216)))
    }()
    
    //MARK:- Inilizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.white
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    //MARK:- Helper Methods
    
    func show(vc: UIViewController, completetionalHandler: @escaping (Int, Int) -> () ) {
        
        MonthYearPickerView.sharedInstance.onDateSelected = completetionalHandler
        commonSetup()
        
        vc.view.addSubview(MonthYearPickerView.sharedInstance)
    }
    
    internal func hide() {
        MonthYearPickerView.sharedInstance.removeFromSuperview()
        self.isHidden = true
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...previousYear {
                years.append(year)
                year -= 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0)+1
        let year  = years[selectedRow(inComponent: 1)]
        
        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
    
}
