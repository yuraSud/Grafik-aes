//
//  HomeViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
        func didOpenMenu()
}
protocol FontNameSizeDelegate {
    func setFontSizeAndSwipe(font:String?, size: CGFloat?, swipe: Bool)
}


class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    var currentDay = Date()
    var selectedDay = Date() {
        didSet {
            //myTable.reloadData()
            // scrollToCurrentDayRow()
            print("didSet select")
        }
    }
    var chooseDay:Date? {
        didSet {
            print("cgoose day is become")
            
        }
    }
    var swipe = true {
        didSet {
            startSwipe(swipe: swipe)
        }
    }
    let identifierCell = "myCell"
    let headerIdentifier = "TableHeader"
    let date = CalendarDate()
    var rightButton = UIButton()
    var leftButton = UIButton()
    var myTable = UITableView()
    
    static let keyForCoiseAES = "myAES"
    var indexAES = 0
    var titleAES = ""
    
    let titlesAES = ["Запорізька АЕС","Південноукраїнська АЕС","Рівненська АЕС","Хмельницька АЕС"]
    var fontName: String? = nil
    var fontSize : CGFloat? = nil
    var leftSwipe = UISwipeGestureRecognizer()
    var rightSwipe = UISwipeGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleAes()
        date.setGrafikAES(index: indexAES)
        view.backgroundColor = UIColor(named: "background")
        setBarButton()
        createTable()
        createFooter()
        loadNameSizeFont()
        becomeActive()
        rightButtons()
        leftButtons()
        print("didLoad")
        startSwipe(swipe: swipe)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Become willAppear")
        date.setGrafikAES(index: indexAES)
        
        myTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DidAppear")
        
        if chooseDay != nil {
            scrollToChooseDayRow(chooseDate: chooseDay ?? selectedDay)
        }
    }
    
    //MARK: - objc functions:
    
    @objc func openMenu(){
        delegate?.didOpenMenu()
    }
    
    @objc func findDate(){
        //delegate?.didFindDate()
        let vc = FindDateViewController()
        //currentDay = Date()
        vc.updatingDate = currentDay
        vc.completionHandler = {[unowned self] (value) in
            print("value = \(value)")
            chooseDay = value
            selectedDay = value
            //currentDay = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func appBecomeActive(){
        selectedDay = Date()
        currentDay = selectedDay
        myTable.reloadData()
        scrollToCurrentDayRow()
        print("appBecomeActive")
    }
    
    @objc func previousMounth(){
        selectedDay = date.previousMonth(date: selectedDay)
        myTable.reloadData()
        scrollToRow()
    }
    
    @objc func nextMounth(){
        selectedDay = date.nextMonth(date: selectedDay)
        myTable.reloadData()
        scrollToRow()
    }
    
    @objc func handleSwipesLeft(){
        guard swipe else { return }
        nextMounth()
        
        }
    
    @objc func handleSwipesRight(){
        guard swipe else { return }
        previousMounth()
        
        }
    
    //MARK: - Others function:
    private func startSwipe(swipe: Bool){
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipesLeft))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipesRight))
        
        if swipe {
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            view.addGestureRecognizer(leftSwipe)
            view.addGestureRecognizer(rightSwipe)
            rightButton.isHidden = true
            leftButton.isHidden = true
        } else {
            rightButton.isHidden = false
            leftButton.isHidden = false
            view.removeGestureRecognizer(leftSwipe)
            view.removeGestureRecognizer(rightSwipe)
        }
    }
    
    
    private func setBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "lis"),
            style: .done,
            target: self,
            action: #selector(openMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "find"),
            style: .done,
            target: self,
            action: #selector(findDate))
        navigationController?.navigationBar.tintColor = UIColor(named: "navigationTint")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func createTable(){
        myTable = UITableView()
        myTable.register(DayTableViewCell.self, forCellReuseIdentifier: identifierCell)
        myTable.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        myTable.separatorStyle = .none
        myTable.backgroundColor = UIColor(named: "background")
        myTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myTable)
    }
    
    func changeMounthLabel() -> String {
        return date.monthString(date: selectedDay)
    }
    
    func createFooter(){
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        footer.backgroundColor = UIColor(named: "background")
        myTable.tableFooterView = footer
    }
    
    func scrollToCurrentDayRow(){
        let indexPath = IndexPath(row: date.dayOfMonth(date: selectedDay) - 1, section: 0)
        myTable.scrollToRow(at: indexPath, at: .top, animated: true)
        print("scroll to current")
    }
    
    func scrollToChooseDayRow(chooseDate: Date){
        let indexPath = IndexPath(row: date.dayOfMonth(date: chooseDate) - 1, section: 0)
        myTable.selectRow(at: indexPath, animated: true, scrollPosition: .middle)

        if chooseDay != nil {
            chooseDay = nil
            print("chooseDay = nil")
        }
        print("scroll to choose")
    }
    
    func scrollToRow(){
        let indexPath = IndexPath(row: 0, section: 0)
        myTable.scrollToRow(at: indexPath, at: .top, animated: true)
        print("prosto scroll")
    }
    
    private func createButton(nameImage: String) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: nameImage), for: .normal)
        button.backgroundColor = UIColor(named: "background")
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 2, height: 7)
        button.layer.shadowOpacity = 40
        button.layer.shadowRadius = 10
        return button
    }
    
    private func becomeActive() {
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    func rightButtons(){
        rightButton = createButton(nameImage: "right")
        view.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(nextMounth), for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func leftButtons(){
        leftButton = createButton(nameImage: "left")
        view.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(previousMounth), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTitleAes(){
        swipe = UserDefaults.standard.bool(forKey: "swipe")
        indexAES = UserDefaults.standard.integer(forKey: HomeViewController.keyForCoiseAES)
        titleAES = titlesAES[indexAES]
        self.title = titleAES
        
    }
    
    func changeFontTitleNavigationBar(name: String?, size: CGFloat?){
        var attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        if let name = name, let size = size {
            attributes = [NSAttributedString.Key.font: UIFont(name: name, size: size)!]
        }
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func loadNameSizeFont(){
        let name = UserDefaults.standard.string(forKey: "fontName")
        let size = CGFloat(UserDefaults.standard.integer(forKey: "fontSize"))
        if name != nil {
            fontName = name
            fontSize = size
        } else {
            fontName = nil
            fontSize = nil
        }
        changeFontTitleNavigationBar(name: fontName, size: fontSize)
    }
}

    
extension HomeViewController: ChoosePlantDelegete, FontNameSizeDelegate {
    func setFontSizeAndSwipe(font: String?, size: CGFloat?, swipe: Bool) {
        self.swipe = swipe
        fontName = font
        fontSize = size
        changeFontTitleNavigationBar(name: font, size: size)
    }
    
    func changeTitleForIndexPlant(index: Int) {
        title = titlesAES[index]
        indexAES = index
    }
}


//MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return date.dayInMonth(date: selectedDay)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as? DayTableViewCell else { return UITableViewCell()}
        
        let dayIndex = date.timeDayInterval(currentDate: selectedDay)
        let allDaysMonth = date.dayInMonth(date: selectedDay)
        
        let aShift = date.configureGraf(modelArray: date.aGrafik, dayIndex: dayIndex, allDayinMonth: allDaysMonth)
        let bShift = date.configureGraf(modelArray: date.bGrafik, dayIndex: dayIndex, allDayinMonth: allDaysMonth)
        let vShift = date.configureGraf(modelArray: date.vGrafik, dayIndex: dayIndex, allDayinMonth: allDaysMonth)
        let gShift = date.configureGraf(modelArray: date.gGrafik, dayIndex: dayIndex, allDayinMonth: allDaysMonth)
        let dShift = date.configureGraf(modelArray: date.dGrafik, dayIndex: dayIndex, allDayinMonth: allDaysMonth)
        cell.removeHolidayImage()
        cell.configureFont(fontName: fontName, size: fontSize)
        
        cell.configureDate(indexes: indexPath.row)
        cell.setCell(label: cell.aLabel, array: aShift, indexes: indexPath.row)
        cell.setCell(label: cell.bLabel, array: bShift, indexes: indexPath.row)
        cell.setCell(label: cell.vLabel, array: vShift, indexes: indexPath.row)
        cell.setCell(label: cell.gLabel, array: gShift, indexes: indexPath.row)
        cell.setCell(label: cell.dLabel, array: dShift, indexes: indexPath.row)
        
        if date.weekendsArray(date: selectedDay).contains(indexPath.row + 1) {
            cell.configureFontByWeekends()
        }
              
        if date.dateIsEqual(currentDate: currentDay, selectedDate: selectedDay) && date.dayOfMonth(date: currentDay) == (indexPath.row + 1) {
            cell.configureCurrentDay()
        }
        if let arrHoliday = date.holidayMonthDay(date: selectedDay) {
            if arrHoliday.contains(indexPath.row + 1) {
                cell.configureByHoliday()
                cell.addHolidayImage()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? TableHeader
        let text = changeMounthLabel()
        let myMutableString = NSMutableAttributedString(string: text)
        myMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: 4))
        header?.daylabel.font = .systemFont(ofSize: 13)
        header?.daylabel.text = text
        header?.daylabel.attributedText = myMutableString
        header?.configureFontHeader(fontName: fontName, size: fontSize)
        return header
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - ADD Constraints

extension HomeViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate(
            [myTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             myTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             myTable.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
             myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
             rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
             rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
             rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor),
             rightButton.widthAnchor.constraint(equalToConstant: 50),
             
             leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
             leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
             leftButton.widthAnchor.constraint(equalToConstant: 50)
            ])
    }
}
