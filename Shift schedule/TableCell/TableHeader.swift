//
//  TableHeader.swift
//  Shift schedule
//
//  Created by YURA																			 on 06.01.2023.
//

import Foundation
import UIKit

class TableHeader: UITableViewHeaderFooterView {
   
    static let identHeader = "TableHeader"
    
    private var alabel = UILabel()
    private var blabel = UILabel()
    private var vlabel = UILabel()
    private var glabel = UILabel()
    private var dlabel = UILabel()
    var daylabel = UILabel()
    private var array = [UILabel]()
    var arraySmenuLabel = [UILabel]()
    
    //var mounthLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "background")
        addLabel()
        addToView()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(textLabel: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        label.text = textLabel
        return label
    }
    
    func configureFontHeader(fontName: String?, size: CGFloat?){
        arraySmenuLabel.forEach{ label in
            if let fontName = fontName, let size = size {
                label.font = UIFont(name: fontName, size: size)
            } else {
                label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            }
        }
    }
    
    private func addLabel(){
        alabel = createLabel(textLabel: "А")
        blabel = createLabel(textLabel: "Б")
        vlabel = createLabel(textLabel: "В")
        glabel = createLabel(textLabel: "Г")
        dlabel = createLabel(textLabel: "Д")
        daylabel = createLabel(textLabel: "День")
        daylabel.numberOfLines = 0
        
        /*mounthLabel = createLabel(textLabel: "Февраль")
        mounthLabel.sizeToFit()*/
        self.array = [daylabel,alabel,blabel,vlabel,glabel,dlabel/*,mounthLabel*/ ]
        self.arraySmenuLabel = [alabel,blabel,vlabel,glabel,dlabel]
    }
    
    private func addToView(){
        array.forEach{ $0.translatesAutoresizingMaskIntoConstraints = false;
            contentView.addSubview($0)
        }
    }
    //MARK: - Constraints
    private func createConstraints(){
               
        NSLayoutConstraint.activate([
            
            daylabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            daylabel.centerYAnchor.constraint(equalTo: alabel.centerYAnchor),
            daylabel.heightAnchor.constraint(equalTo: alabel.heightAnchor),
            daylabel.widthAnchor.constraint(equalTo: alabel.widthAnchor),
            
            alabel.leadingAnchor.constraint(equalTo: daylabel.trailingAnchor, constant: 10),
            alabel.heightAnchor.constraint(equalToConstant: 40),
            alabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            
            blabel.widthAnchor.constraint(equalTo: alabel.widthAnchor),
            blabel.heightAnchor.constraint(equalTo: alabel.heightAnchor),
            blabel.leadingAnchor.constraint(equalTo: alabel.trailingAnchor, constant: 10),
            blabel.centerYAnchor.constraint(equalTo: alabel.centerYAnchor),
            
            vlabel.widthAnchor.constraint(equalTo: alabel.widthAnchor),
            vlabel.heightAnchor.constraint(equalTo: alabel.heightAnchor),
            vlabel.leadingAnchor.constraint(equalTo: blabel.trailingAnchor, constant: 10),
            vlabel.centerYAnchor.constraint(equalTo: alabel.centerYAnchor),
            
            glabel.widthAnchor.constraint(equalTo: alabel.widthAnchor),
            glabel.heightAnchor.constraint(equalTo: alabel.heightAnchor),
            glabel.leadingAnchor.constraint(equalTo: vlabel.trailingAnchor, constant: 10),
            glabel.centerYAnchor.constraint(equalTo: alabel.centerYAnchor),
            
            dlabel.widthAnchor.constraint(equalTo: alabel.widthAnchor),
            dlabel.heightAnchor.constraint(equalTo: alabel.heightAnchor),
            dlabel.leadingAnchor.constraint(equalTo: glabel.trailingAnchor, constant: 10),
            dlabel.centerYAnchor.constraint(equalTo: alabel.centerYAnchor),
            dlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
           /* mounthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mounthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mounthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mounthLabel.bottomAnchor.constraint(equalTo: alabel.topAnchor, constant: 5)     */])
    }
    
}

