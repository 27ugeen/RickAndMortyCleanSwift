//
//  SceneDelegate.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let detailsFactory = CharacterDetailsFactory()
        let router = CharactersListRouter(detailsFactory: detailsFactory)
        let networkService = NetworkService()
        let interactor = CharactersListInteractor(networkService: networkService)
        let presenter = CharactersListPresenter()

        let viewController = CharactersListViewController(interactor: interactor, router: router)

        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        
        self.window = window
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}
