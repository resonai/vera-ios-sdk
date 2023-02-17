//
//  TestSizeViewController.swift
//  VeraSDKExample-CP
//
//  Created by Alex Culeva on 01.10.2022.
//

import UIKit
import VeraSDK

final class TestSizeViewController: UIViewController {
    private let vera = VeraService()

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

        vera.configure()

        view.backgroundColor = .white

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
        guard let vc = vera.build() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func partialButtonTapped() {
        removeVera()
        guard let vc = vera.build() else { return }

        vc.willMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.heightAnchor.constraint(equalToConstant: 240),
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])

        vc.didMove(toParent: self)
    }

    private func removeVera() {
        guard let veraVC = vera.viewController else { return }
        if let parent = veraVC.parent, parent === self {
            veraVC.willMove(toParent: nil)
            veraVC.view.removeFromSuperview()
            veraVC.didMove(toParent: nil)
        }
        vera.remove()
    }
}
