//
//  DayTableViewCell.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    var dateLabel = UILabel()
    var aLabel = UILabel()
    var bLabel = UILabel()
    var vLabel = UILabel()
    var gLabel = UILabel()
    var dLabel = UILabel()
   
   
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    let imageHolidayLabel: UIImageView = {
       let image = UIImage(named: "confetti")
        let imageL = UIImageView(image: image)
        imageL.contentMode = .scaleAspectFit
        imageL.translatesAutoresizingMaskIntoConstraints = false
        return imageL
    }()
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.heightAnchor.constraint(equalTo: label.widthAnchor).isActive = true
        return label
    }
    
    private func addLabel(){
        aLabel = createLabel()
        bLabel = createLabel()
        vLabel = createLabel()
        gLabel = createLabel()
        dLabel = createLabel()
        dateLabel = createLabel()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addLabel()
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(aLabel)
        stackView.addArrangedSubview(bLabel)
        stackView.addArrangedSubview(vLabel)
        stackView.addArrangedSubview(gLabel)
        stackView.addArrangedSubview(dLabel)
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addHolidayImage(){
        dateLabel.addSubview(imageHolidayLabel)
        NSLayoutConstraint.activate([
            imageHolidayLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            imageHolidayLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            imageHolidayLabel.heightAnchor.constraint(equalTo: imageHolidayLabel.widthAnchor),
            imageHolidayLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor, multiplier: 0.4)])
    }
    func removeHolidayImage(){
        imageHolidayLabel.removeFromSuperview()
    }
  
    func configureDate(indexes:Int){
        dateLabel.text = "\(indexes + 1)"
    }
    
   // Change "9" to "-" when days vuhodnoy
    func setCell(label: UILabel, array:[Int], indexes:Int){
        label.text = array[indexes] == 9 ? "-" : "\(array[indexes])"
    }
    
    func configureFont(fontName: String?, size: CGFloat?){
        let arrayLabel = [dateLabel,aLabel,bLabel,vLabel,gLabel,dLabel]
        
        arrayLabel.forEach{ label in
            if let fontName = fontName, let size = size {
                label.font = UIFont(name: fontName, size: size)
            } else {
                label.font = UIFont.systemFont(ofSize: 26)
            }
            label.adjustsFontSizeToFitWidth = true
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 4
       // Color
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.backgroundColor = UIColor.clear.cgColor
            
        }
    }
    
    func configureCurrentDay(){
        let arrayLabel = [aLabel,bLabel,vLabel,gLabel,dLabel]
     //Color
        dateLabel.layer.backgroundColor = UIColor(named: "borderCurrent")?.cgColor
    //Color
        arrayLabel.forEach{ label in
            label.layer.borderColor = UIColor(named: "borderCurrent")?.cgColor
            label.layer.backgroundColor = UIColor(named: "myColor")?.cgColor
        }
    }
    
    func configureFontByWeekends(){
        let arrayLabel = [aLabel,bLabel,vLabel,gLabel,dLabel]
   //Color
        dateLabel.layer.borderColor = UIColor(named: "background")?.cgColor
        dateLabel.layer.backgroundColor = UIColor(named: "background")?.cgColor
    //Color
        arrayLabel.forEach{ label in
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.backgroundColor = UIColor(named: "weekend")?.cgColor
        }
    }
    
    func configureByHoliday(){
        dateLabel.layer.backgroundColor = UIColor(named: "holiday")?.cgColor
    }
    
}
