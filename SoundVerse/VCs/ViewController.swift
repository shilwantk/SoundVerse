//
//  ViewController.swift
//  SoundVerse
//
//  Created by Kirti on 2/28/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let sideMenu: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var isMenuOpen = false
    var menuLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        setupUI()
        setupSideMenu()
        setupGestures()
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func setupUI() {

        let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = menuBarButton
        
        let notificationBarButton = UIBarButtonItem(image: UIImage(systemName: "bell.fill"),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(openNotificationScreen))
        navigationItem.rightBarButtonItem = notificationBarButton
        
        view.addSubview(messageTextField)
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupSideMenu() {
        view.addSubview(sideMenu)
        menuLeadingConstraint = sideMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -250)
        NSLayoutConstraint.activate([
            menuLeadingConstraint,
            sideMenu.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenu.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupGestures() {
        let swipeOpen = UISwipeGestureRecognizer(target: self, action: #selector(menuTapped))
        swipeOpen.direction = .right
        view.addGestureRecognizer(swipeOpen)
        let swipeClose = UISwipeGestureRecognizer(target: self, action: #selector(menuTapped))
        swipeClose.direction = .left
        sideMenu.addGestureRecognizer(swipeClose)
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    @objc func openNotificationScreen() {
        let notificationVC = NotificationViewController()
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func menuTapped() {
        UIView.animate(withDuration: 0.3) {
            if let navController = self.navigationController {
                self.menuLeadingConstraint.constant = self.isMenuOpen ? -250 : 0
                navController.view.layoutIfNeeded()
            } else {
                self.menuLeadingConstraint.constant = self.isMenuOpen ? -250 : 0
                self.view.layoutIfNeeded()
            }
        }
        isMenuOpen.toggle()
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let webVC = WebViewController(url: URL(string: "https://www.soundverse.ai/")!)
        navigationController?.pushViewController(webVC, animated: true)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let alert = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        completionHandler([.sound])
    }
}
