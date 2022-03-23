//
//  ViewController.swift
//  VeraSDKExample-SPM
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
            app: .init(clientID: "test"),
            user: .init(username: nil),
            link: .init(path: nil),
            eventHandler: { [weak self] in self?.handleVeraEvent($0) }
        )

        let vc = VeraViewController.build(config: config)
        self.vera = vc
        present(vc, animated: true)
    }

    private func handleVeraEvent(_ event: VeraConfiguration.Event) {
        switch event {
        case .refreshToken:
            vera.handleEvent(.updateToken(.anonymous))
        @unknown default:
            fatalError()
        }
    }
}

