//
//  AddViewController.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 25.08.23.
//

import UIKit
import UserNotifications

class AddViewController: UIViewController {
    
    // MARK: - Propeties
    
    let textFieldPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    let titleField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Title...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    let amountField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Dosage in milligrams...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.black, forKey: "textColor")
        let loc = Locale(identifier: "us")
        datePicker.locale = loc
        return datePicker
    }()
    
    
    public var completion: ((String, Int, Date) -> Void)?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
    }
    
    
    // MARK: - Selectors
    
  @objc func didTapSaveButton() {
     
        if let titleText = titleField.text, !titleText.isEmpty,
           let amountText = amountField.text, !amountText.isEmpty {
            let targetDate = datePicker.date
            
            guard let amount = Int(amountText) else { return }

            completion?(titleText, amount, targetDate)
            
            self.dispatchNotification(title: titleText, amount: amountText, date: targetDate)
            
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    // MARK: - Helper Functions
    
    func dispatchNotification(title: String, amount: String, date: Date) {
        let identifier = title
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = "\(amount) mg"
        content.sound = .default
        
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    func configureViewComponents() {
        view.backgroundColor = .lightGray
        
        title = "New Medication"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(titleField)
        titleField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 20, height: 52)
        
        view.addSubview(amountField)
        amountField.anchor(top: titleField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 20, height: 52)
        
       view.addSubview(datePicker)
        datePicker.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 20, height: view.frame.height/2)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

