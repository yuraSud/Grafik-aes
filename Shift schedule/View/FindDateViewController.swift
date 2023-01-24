//
//  FindDateViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

class FindDateViewController: UIViewController {

    var updatingDate: Date = Date()
    
    var completionHandler: ((Date)->Void)?
    
    private var pickerDate: Date?
    private let dateToStart = CalendarDate().dateToStart
   
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.text = "Виберіть дату до якої бажаєте перейти:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let popButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
        button.setTitle("Перейти до дати", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let datePicker: UIDatePicker = {
       let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        let loc = Locale(identifier: "uk")
        dp.locale = loc
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вибір дати"
        view.backgroundColor = UIColor(named: "backGroundMenu")
        navigationItem.largeTitleDisplayMode = .never
        addLabel()
        addPicker()
        addButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = updatingDate
    }
    
    private func addLabel(){
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo:navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 30)])
    }
    private func addButton(){
        view.addSubview(popButton)
        NSLayoutConstraint.activate([popButton.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),
            popButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 50),
            popButton.heightAnchor.constraint(equalToConstant: 42),
            popButton.widthAnchor.constraint(equalToConstant: 150)])
        
        popButton.addTarget(self, action: #selector(backToTable), for: .touchUpInside)
    }

    private func addPicker(){
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            datePicker.leadingAnchor.constraint(equalTo: label.leadingAnchor)])
        datePicker.minimumDate = dateToStart
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(chooseDate(choiseDate:)), for: .valueChanged)
    }
    
    @objc func chooseDate(choiseDate: UIDatePicker){
        if choiseDate == datePicker {
            print(choiseDate.date)
        }
    }
   
    @objc func backToTable(){
        let updateDate = datePicker.date
        print("updateDate = \(updateDate)")
        completionHandler?(updateDate)
        navigationController?.popViewController(animated: true)
        
    }
}
