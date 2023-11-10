//
//  ViewController.swift
//  VeraSDKExample-CP
//
//  Created by S2dent on 19.03.2022.
//

import UIKit
import VeraSDK

class ViewController: UIViewController {
    var vera: UIViewController?

    private lazy var fullscreenButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Test Fullscren", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(fullscreenButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 4

        return button
    }()

    private lazy var partialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Test Part of Screen", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(partialButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 4

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .gray
        navigationController?.delegate = self
        title = "Vera Example"

        view.addSubview(partialButton)
        view.addSubview(fullscreenButton)

        NSLayoutConstraint.activate([
            partialButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            partialButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            partialButton.widthAnchor.constraint(equalToConstant: 196),
            fullscreenButton.bottomAnchor.constraint(equalTo: partialButton.topAnchor, constant: -12),
            fullscreenButton.centerXAnchor.constraint(equalTo: partialButton.centerXAnchor),
            partialButton.widthAnchor.constraint(equalTo: fullscreenButton.widthAnchor)
        ])
    }

    @objc func fullscreenButtonTapped() {
        removeVera()
        guard let vera = buildVera() else { return }

        let container = containerVC()
        container.title = "Fullscreen"

        vera.willMove(toParent: container)
        container.view.addSubview(vera.view)
        vera.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vera.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
            vera.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor),
            vera.view.heightAnchor.constraint(equalTo: container.view.heightAnchor),
            vera.view.topAnchor.constraint(equalTo: container.view.topAnchor)
        ])

        vera.didMove(toParent: container)

        navigationController?.pushViewController(container, animated: true)
    }

    @objc func partialButtonTapped() {
        removeVera()
        guard let vera = buildVera() else { return }

        let container = containerVC()
        container.title = "Partial"

        vera.willMove(toParent: container)
        container.view.addSubview(vera.view)
        vera.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vera.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
            vera.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor),
            vera.view.heightAnchor.constraint(equalToConstant: 240),
            vera.view.topAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])

        vera.didMove(toParent: container)

        navigationController?.pushViewController(container, animated: true)
    }

    @objc func sendDeepLink() {
        let deepLink = "https://vera.resonai.com/#/play/sdk-sample-site/com.resonai.navigation/%7B%22key%22%3A%228207e1fe-3c5a-11ee-9750-12f3c6ba63d8%22%7D"
        Vera.handleEvent(.sendDeeplink(deepLink))
    }

    private func containerVC() -> UIViewController {
        let vc = UIViewController()
        vc.navigationItem.rightBarButtonItem = .init(title: "Deeplink", style: .plain, target: self, action: #selector(sendDeepLink))
        vc.view.backgroundColor = .white

        return vc
    }

    private func removeVera() {
        guard let vera = vera else { return }
        if let parent = vera.parent, parent === self {
            vera.willMove(toParent: nil)
            vera.view.removeFromSuperview()
            vera.didMove(toParent: nil)
        }
        self.vera = nil
    }

    private func buildVera() -> UIViewController? {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            /// Most of these configuration parameters are unnecessary and have default values.
            /// They are added here to inform about their existence.
            Vera.useConfig(
                .init(
                    domain: URL(string: "https://vera.resonai.com")!,
                    registration: .init(
                        url: URL(string: "registration.resonai.com")!,
                        port: 443
                    ),
                    app: .init(
                        clientID: "",
                        siteIDs: ["sdk-sample-site"],
                        shouldShowCloseButton: false,
                        hideHeader: true
                    ),
                    auth: .init(username: nil),
                    language: .en
                )
            )
        }

        /// Make sure to configure the global event handler before starting Vera
        /// to avoid losing any necessary events.
        Vera.useEventHandler { [weak self] event in
            switch event {
            case let .handleMessage(sender: sender, data: data):
                let alert = UIAlertController()
                alert.title = sender
                alert.message = data
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            case .login:
                print("login")
            case .logout:
                print("logout")
            case .refreshToken:
                print("refresh token")
            @unknown default:
                print("Got unknown event \(event)")
            }
        }


        let vc = Vera.getController()
        self.vera = vc

        return vc
    }
}

extension ViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard viewController === self else { return }
        vera = nil
    }
}
