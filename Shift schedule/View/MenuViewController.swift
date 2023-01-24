//
//  MenuViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.Menu)
}

class MenuViewController: UIViewController {

    weak var delegate: MenuViewControllerDelegate?
    
    enum Menu: String, CaseIterable {
        case home = "На головну"
        case options = "Налаштування"
        case coise = "Вибір АЕС"
        case info = "Інфо"
        case notes = "Створити замітку!"
        case empty = " "
        case number = "Цифри"
    }
    
    var indexAES = 0
    let menuItems = ["На головну","Налаштування","Вибір АЕС","Інфо","Створити замітку"," ","Цифри"]
    let images = ["physics","setting", "choice","info","broken-link","more","number-blocks"]
    
    
    let myTable: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "MenuColor")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "zaes")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 7/16),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            myTable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            myTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MenuColor")
        view.addSubview(imageView)
        view.addSubview(myTable)
        myTable.delegate = self
        myTable.dataSource = self
        setImageAes()
    }
    
  
}

//MARK: - Dekegate and Data Source

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        let image = UIImage(named: images[indexPath.row])
        
        
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = menuItems[indexPath.row]
            config.textProperties.color = .white
            config.textProperties.font = .boldSystemFont(ofSize: 20)
            config.image = image
            config.imageProperties.maximumSize = .init(width: 20, height: 20)
            cell.contentConfiguration = config
            
        } else {
            cell.imageView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            cell.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
            cell.textLabel?.text = menuItems[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = .boldSystemFont(ofSize: 20)
            cell.imageView?.image = image
            
        }
        cell.backgroundColor = UIColor(named: "MenuColor")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = Menu.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}

extension MenuViewController: ChoosePlantDelegete {
    func changeTitleForIndexPlant(index: Int) {
        indexAES = index
        let nameImage = ChoosePlantViewController().imageArray[indexAES]
        imageView.image = UIImage(named: nameImage)
        
    }
    func setImageAes(){
        indexAES = UserDefaults.standard.integer(forKey: HomeViewController.keyForCoiseAES)
        let nameImage = ChoosePlantViewController().imageArray[indexAES]
        imageView.image = UIImage(named: nameImage)
    }
    
    
}
