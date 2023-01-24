//
//  ChoosePlantViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

protocol ChoosePlantDelegete {
    func changeTitleForIndexPlant(index: Int)
}


class ChoosePlantViewController: UIViewController {

    var changeBool: Bool = false {
        didSet {
            print("changeBool=\(changeBool)")
            if changeBool {
                popButton.isHidden = false
            } else {
                popButton.isHidden = true
            }
        }
    }
    var handleChooseIndexDelegate: ChoosePlantDelegete?
    var handleChooseIndexMenuDelegate: ChoosePlantDelegete?
    var chooseIndex: Int = 0
    let keyForCoiseAES = "myAES"
    
    let imageArray = ["zaes","yuaes","raes","xaes"]
   
    
    private let label: UILabel = {
       let lab = UILabel()
        lab.text = "Виберіть АЕС для якої буде відображатись графік змін:"
        lab.font = .systemFont(ofSize: 18)
        lab.textAlignment = .left
        lab.numberOfLines = 0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    private let plantLabel: UILabel = {
       let lab = UILabel()
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .boldSystemFont(ofSize: 17)
        lab.textColor = .systemBlue
        return lab
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "zaes")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        //imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOffset = CGSize(width: 7, height: 5)
        imageView.layer.frame = imageView.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    private let segmentControl: UISegmentedControl = {
        let menu = ["ЗАЕС","ПУАЕС","РАЕС","ХАЕС"]
        let sc = UISegmentedControl(items: menu)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        sc.layer.shadowOffset = CGSize(width: 4, height: 4)
        sc.layer.shadowRadius = 10
        sc.layer.shadowOpacity = 0.9
        sc.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            sc.selectedSegmentTintColor = .link
        } 
        return sc
    }()
    
    private let popButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
        button.setTitle("Зберегти вибір", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backGroundMenu")
        navigationItem.title = "Вибір АЕС"
        navigationItem.largeTitleDisplayMode = .never
        addLabelAndImage()
        addSegment()
        addButton()
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            plantLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            plantLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            plantLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 35),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8),
            
            segmentControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            segmentControl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            popButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 30),
            popButton.centerXAnchor.constraint(equalTo: segmentControl.centerXAnchor),
            popButton.heightAnchor.constraint(equalToConstant: 45),
            popButton.widthAnchor.constraint(equalTo: popButton.heightAnchor, multiplier: 3)
        ])
    }
    
    func addLabelAndImage(){
        view.addSubview(label)
        view.addSubview(plantLabel)
        view.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        plantLabel.text = HomeViewController().titlesAES[chooseIndex]
    }
    
    func addSegment(){
        view.addSubview(segmentControl)
        segmentControl.selectedSegmentIndex = chooseIndex
        imageView.image = UIImage(named: imageArray[chooseIndex])
       
        segmentControl.addTarget(self, action: #selector(segment), for: .valueChanged)
    }
    
    func addButton(){
        view.addSubview(popButton)
        popButton.addTarget(self, action: #selector(saveChange), for: .touchUpInside)
        popButton.isHidden = true
    }
    
    @objc func saveChange(){
        let index = segmentControl.selectedSegmentIndex
        changeBool = false
        UserDefaults.standard.set(index, forKey: keyForCoiseAES)
        handleChooseIndexDelegate?.changeTitleForIndexPlant(index: index)
        handleChooseIndexMenuDelegate?.changeTitleForIndexPlant(index: index)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func segment(){
        let index = segmentControl.selectedSegmentIndex
        changeBool = true
        plantLabel.text = HomeViewController().titlesAES[index]
        imageView.image = UIImage(named: imageArray[index])
    }
}
