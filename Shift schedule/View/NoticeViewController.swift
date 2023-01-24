//
//  NoticeViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 19.01.2023.
//

import UIKit
import UserNotifications

class NoticeViewController: UIViewController, UITextFieldDelegate /*UNUserNotificationCenterDelegate*/ {
    
    private let dateToStart = Date()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.text = "Виберіть дату та час в який спрацює повідомлення:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let popButton: UIButton = {
        let button = UIButton()
        button.setTitle("Створити повідомлення", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        let loc = Locale(identifier: "uk")
        dp.locale = loc
        return dp
    }()
    
    private let titleNoticeTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 20)
        tf.placeholder = "Введіть тему замітки:"
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 7
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let bodyNoticeTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 20)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 7
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(named: "backGroundMenu")
        tf.placeholder = "Введіть текст замітки (коротко)..."
        
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Створити повідомлення"
        view.backgroundColor = UIColor(named: "backGroundMenu")
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(label)
        addButton()
        addPicker()
        addTextFields()
        notification()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            datePicker.topAnchor.constraint(equalTo: bodyNoticeTextField.bottomAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleNoticeTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            titleNoticeTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            titleNoticeTextField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            
            bodyNoticeTextField.topAnchor.constraint(equalTo: titleNoticeTextField.bottomAnchor, constant: 20),
            bodyNoticeTextField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            bodyNoticeTextField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                        
            popButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            popButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            popButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            popButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    private func addTextFields(){
        view.addSubview(titleNoticeTextField)
        view.addSubview(bodyNoticeTextField)
        titleNoticeTextField.delegate = self
        bodyNoticeTextField.delegate = self
    }
    func notification(){
        //notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert,.sound, .badge]) { (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission Denied")
            }
        }
    }
    
    private func addPicker(){
        view.addSubview(datePicker)
        datePicker.minimumDate = dateToStart
        datePicker.datePickerMode = .dateAndTime
        /*
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        //datePicker.addTarget(self, action: #selector(chooseDate(choiseDate:)), for: .valueChanged)*/
    }
    private func addButton(){
        view.addSubview(popButton)
        
        popButton.addTarget(self, action: #selector(createNotice), for: .touchUpInside)
    }
    
    @objc func createNotice(){
        guard (!(titleNoticeTextField.text?.isEmpty ?? false) ) || (!(bodyNoticeTextField.text?.isEmpty ?? false)) else {
            let ac = UIAlertController(title: "Увага", message: "Ви не ввели жодного символу, повинен бути хоч якийсь текст", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}) )
            self.present(ac, animated: true)
            return}
        notificationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async {
                let title = self.titleNoticeTextField.text ?? "none"
                let message = self.bodyNoticeTextField.text ?? "nil"
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = .defaultCritical
                    
                    let dateComp = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Створити замітку", message: "Для цієї дати: " + self.formattedDate(date:date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        print("hjkj")
                        self.navigationController?.popViewController(animated: true)
                        
                    }) )
                    self.present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "Для використання цієї опції, тобі потрібно перейти в налаштування", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) {
                        (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if (UIApplication.shared.canOpenURL(settingsURL)) {
                            UIApplication.shared.open(settingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleNoticeTextField {
            bodyNoticeTextField.becomeFirstResponder()
        } else if textField == bodyNoticeTextField {
            view.endEditing(true)
        }
    return true
    }
    
}
