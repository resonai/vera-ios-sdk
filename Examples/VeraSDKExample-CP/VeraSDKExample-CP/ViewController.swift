//
//  ViewController.swift
//  VeraSDKExample-CP
//
//  Created by S2dent on 19.03.2022.
//

import UIKit

class ViewController: UIViewController {

    private lazy var testSizeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Test Size", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(testSizeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(testSizeButton)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            testSizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testSizeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testSizeButton.widthAnchor.constraint(equalToConstant: 96)
        ])
    }

    @objc func testSizeButtonTapped() {
        navigationController?.pushViewController(TestSizeViewController(), animated: true)
    }
}
