//
//  SceneDelegate.swift
//  Bankey
//
//  Created by dan phi on 23/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let onboardingVC = OnboardingContainerViewController()
    let mainVC = MainViewController()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScreen = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScreen)
        loginViewController.delegate = self
        onboardingContainerViewController.delegate = self
        mainVC.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = .red
        window.rootViewController = loginViewController
        registerForNotifications()
        window.makeKeyAndVisible()
        self.window = window
        
    }
    
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
}
//MARK: DELEGATE

extension SceneDelegate: LoginViewControllerDelegate, OnboardingContainerViewControllerDelegate, LogoutDelegate {
    
    func didLogin() {
        if LocalStorage.hasOnboarded {
            setRootViewController(mainVC)
        } else {
            setRootViewController(onboardingVC)
        }
    }
    
    
    func didFisnishOnboarding() {
        LocalStorage.hasOnboarded = true
        setRootViewController(mainVC)
    }
    
    @objc func didLogout() {
        setRootViewController(loginViewController)
    }
    
}

