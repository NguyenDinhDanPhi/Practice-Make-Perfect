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
    let dumyVc = DummyViewController()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScreen = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScreen)
        loginViewController.delegate = self
        onboardingContainerViewController.delegate = self
        dumyVc.logoutDelegate = self
        window.rootViewController = loginViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func setRootView(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }


}
//MARK: DELEGATE

extension SceneDelegate: LoginViewControllerDelegate, OnboardingContainerViewControllerDelegate, LogoutDelegate {
    func didLogout() {
        setRootView(loginViewController)

    }
    
    func didFisnishOnboarding() {
        LocalStorage.hasOnboarded = true
        setRootView(dumyVc)
    }
    
    func didLogin() {
        if LocalStorage.hasOnboarded {
            setRootView(dumyVc)
        } else {
            setRootView(onboardingContainerViewController)
        }
    }
    
    
}
