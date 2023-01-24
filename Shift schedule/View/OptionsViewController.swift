//
//  OptionsViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

enum Theme: Int {
    case device
    case light
    case dark
    
    func getUserInterface() -> UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class OptionsViewController: UIViewController {
    
    enum PickerSection {
        case font(fonts: [String])
        case size(sizes: [Int])
    }
    
    var completionHandler: FontNameSizeDelegate?
    var localeDataSource = [PickerSection]()
    var fontName : String?
    var fontSize : CGFloat?
    var swipe = true
    
    private let labelFont: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = " - Виберіть тему вашого застосунку:"
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .darkGray
        return lab
    }()
    
    private let labelchangeFont: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = " - Виберіть стиль шрифту та розмір тексту у таблиці:"
        lab.textColor = .darkGray
        lab.numberOfLines = 0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private let labelSwipeOptions: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = " - Використовувати свайпи замість кнопок для зміни місяця:"
        lab.numberOfLines = 0
        lab.textColor = .darkGray
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private let testLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.text = "Тест шрифта: 1, 2, 3, - "
        lab.numberOfLines = 1
        lab.layer.borderWidth = 1
        lab.layer.cornerRadius = 8
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private let segmentControl: UISegmentedControl = {
        let menu = ["Device","Light","Dark"]
        let sc = UISegmentedControl(items: menu)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let saveButton: UIButton = {
       let button = UIButton()
        button.setTitle("Зберегти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        // button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private let defaultButton: UIButton = {
       let button = UIButton()
        button.setTitle("За замовчуванням", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemRed, for: .highlighted)
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray
        //button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   private let switche = UISwitch()
    
    var horizontalStack = UIStackView()
    
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backGroundMenu")
        title = "Налаштування"
        navigationItem.largeTitleDisplayMode = .never
        addlabel()
        addSegmentControl()
        localeDataSource.append(.font(fonts: UIFont.familyNames))
        localeDataSource.append(.size(sizes: Array(13...34)))
        pickerView.dataSource = self
        pickerView.delegate = self
        addStackWithButtons()
        addSwitch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            labelSwipeOptions.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelSwipeOptions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelSwipeOptions.trailingAnchor.constraint(equalTo: switche.leadingAnchor, constant: -10),
            
            switche.centerYAnchor.constraint(equalTo: labelSwipeOptions.centerYAnchor),
            switche.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            labelFont.topAnchor.constraint(equalTo: labelSwipeOptions.bottomAnchor, constant: 30),
            labelFont.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelFont.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
           
            segmentControl.topAnchor.constraint(equalTo: labelFont.bottomAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: labelFont.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: labelFont.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            labelchangeFont.leadingAnchor.constraint(equalTo: labelFont.leadingAnchor),
            labelchangeFont.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 30),
            labelchangeFont.trailingAnchor.constraint(equalTo: labelFont.trailingAnchor),
            
            pickerView.centerXAnchor.constraint(equalTo: labelFont.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: -15),
            
            testLabel.leadingAnchor.constraint(equalTo: labelFont.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: labelFont.trailingAnchor),
            testLabel.topAnchor.constraint(equalTo: labelchangeFont.bottomAnchor, constant: 5),
            testLabel.heightAnchor.constraint(equalToConstant: 40),
            
            horizontalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            horizontalStack.heightAnchor.constraint(equalToConstant: 45)
            
            ])
    }
    
    func addlabel(){
        view.addSubview(labelFont)
        view.addSubview(labelchangeFont)
        view.addSubview(pickerView)
        view.addSubview(testLabel)
        view.addSubview(labelSwipeOptions)
    }

    func addSegmentControl(){
        view.addSubview(segmentControl)
        segmentControl.addTarget(self, action: #selector(segmentTheme), for: .valueChanged)
        let segment = UserDefaults.standard.integer(forKey: "segment")
            segmentControl.selectedSegmentIndex = segment
    }
    func addSwitch(){
        view.addSubview(switche)
        switche.translatesAutoresizingMaskIntoConstraints = false
        switche.isOn = swipe
        switche.addTarget(self, action: #selector(addSwipe), for: .valueChanged)
    }
    
    func addStackWithButtons(){
         horizontalStack = UIStackView(arrangedSubviews: [saveButton,defaultButton])
        view.addSubview(horizontalStack)
        horizontalStack.spacing = 15
        horizontalStack.contentMode = .center
        horizontalStack.distribution = .fillEqually
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.addTarget(self, action: #selector(saveOptions), for: .touchUpInside)
        defaultButton.addTarget(self, action: #selector(defaultsOptions), for: .touchUpInside)
    }
    
    @objc func addSwipe(){
        swipe = switche.isOn
        print(swipe)
    }
    
    @objc func saveOptions(){
        UserDefaults.standard.set(swipe, forKey: "swipe")
        UserDefaults.standard.set(fontName, forKey: "fontName")
        UserDefaults.standard.set(fontSize, forKey: "fontSize")
        
        completionHandler?.setFontSizeAndSwipe(font: fontName, size: fontSize, swipe: swipe)
         navigationController?.popViewController(animated: true)
    }
    
    @objc func defaultsOptions(){
        testLabel.font = UIFont.systemFont(ofSize: 26)
        fontName = nil
        fontSize = nil
        swipe = false
        saveOptions()
    }
    
    @objc func segmentTheme(){
        UserDefaults.standard.set(segmentControl.selectedSegmentIndex, forKey: "segment")
        let obj = Theme(rawValue: UserDefaults.standard.integer(forKey: "segment"))
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = obj?.getUserInterface() ?? .unspecified
        }
    }

}

extension OptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return localeDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch localeDataSource[component] {
        case .font(let fonts):
            return fonts.count
        case .size(let sizes):
            return sizes.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var text = ""
        switch localeDataSource[component] {
        case .font(let fonts):
            text = fonts[row]
        case .size(let sizes):
            text = String(sizes[row])
        }
        return NSAttributedString(string: text)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch localeDataSource[component] {
        case .font(let fonts):
            testLabel.font = UIFont.init(name: fonts[row], size: testLabel.font.pointSize)
            fontName = fonts[row]
        case .size(let sizes):
            testLabel.font = UIFont(name: testLabel.font.fontName, size: CGFloat(sizes[row]))
            fontSize = CGFloat(sizes[row])
        }
    }
    
}
