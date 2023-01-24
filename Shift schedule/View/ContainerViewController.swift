//
//  ContainerViewController.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import UIKit

class ContainerViewController: UIViewController {

    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    var navigationVC: UINavigationController?
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    lazy var optionsVC = OptionsViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      addChildrenVC()
    }
    
    private func addChildrenVC() {
        
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
   
        homeVC.delegate = self
        let  navigationVC = UINavigationController(rootViewController: homeVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        addChild(navigationVC)
        view.addSubview(navigationVC.view)
        navigationVC.didMove(toParent: self)
        self.navigationVC = navigationVC
    }

   
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didOpenMenu() {
       toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (()->Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navigationVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] (done) in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navigationVC?.view.frame.origin.x = 0
            } completion: { [weak self] (done) in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.Menu) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            resetToHome()
        case .options:
            addOptionsVC()
        case .coise:
            addCoosePlantVC()
        case .info:
            break
        case .notes:
            addNoticeVC()
        case .empty:
            break
        case .number:
            break
        }
    }
    
    
    func addCoosePlantVC(){
        let vc = ChoosePlantViewController()
        vc.chooseIndex = homeVC.indexAES
        vc.handleChooseIndexMenuDelegate = menuVC
        vc.handleChooseIndexDelegate = homeVC
        navigationVC?.pushViewController(vc, animated: true)
    }
    
    func addNoticeVC(){
        let vc = NoticeViewController()
        
        navigationVC?.pushViewController(vc, animated: true)
    }
    func addOptionsVC(){
        let vc = OptionsViewController()
        vc.completionHandler = homeVC
        vc.swipe = homeVC.swipe
        navigationVC?.pushViewController(vc, animated: true)
    }
    
    func resetToHome(){
        navigationController?.popToRootViewController(animated: true)
    }
}
