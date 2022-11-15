//
//  ViewController.swift
//  VeraSDKExample-CP
//
//  Created by S2dent on 19.03.2022.
//

import UIKit
import VeraSDK

class ViewController: UIViewController {

    private var vera: VeraViewController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let config = VeraConfiguration(
            language: .he,
            app: .init(
                clientID: "test",
                shouldShowCloseButton: true
            ),
            auth: .init(username: nil)
        ) { [weak self] event in
            switch event {
            case .refreshToken:
                self?.vera.handleEvent(.updateToken(.anonymous))
            case .login, .logout, .handleMessage:
                break
            @unknown default:
                break
            }
        }

        let vc = VeraViewController.build(config: config)
        self.vera = vc
        present(vc, animated: true)
    }
}

