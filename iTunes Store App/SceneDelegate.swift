//
//  SceneDelegate.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let viewController = RankingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let tabBar = UITabBar()
        let musicTabBar =  UITabBarItem(title: "音樂", image: UIImage(systemName: "music.note"), tag: 1)
        let filmTabBar = UITabBarItem(title: "電影", image: UIImage(systemName: "film.fill"), tag: 2)
        let searchTabBar = UITabBarItem(title: "搜尋", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        let bellTabBar = UITabBarItem(title: "鈴聲", image: UIImage(systemName: "bell.fill"), tag: 4)
        let moreTabBar = UITabBarItem(title: "更多", image: UIImage(systemName: "ellipsis"), tag: 5)

        tabBar.items = [musicTabBar, filmTabBar, searchTabBar, bellTabBar, moreTabBar]
        tabBar.selectedItem = musicTabBar
        tabBar.barTintColor = .black

        viewController.view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

