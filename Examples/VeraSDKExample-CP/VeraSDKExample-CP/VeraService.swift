//
//  VeraService.swift
//  VeraSDKExample-CP
//
//  Created by Alex Culeva on 16.02.2023.
//

import FirebaseCore
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI
import VeraSDK

final class VeraService: NSObject {
    private(set) var viewController: VeraViewController?

    func build() -> VeraViewController? {
        let vc = Vera.getController()
        self.viewController = vc

        return vc
    }

    func remove() {
        viewController = nil
    }

    func configure() {
        Vera.useConfig(
            .init(
                domain: URL(string: "https://beta-vera.resonai.com")!,
                registration: .init(
                    url: URL(string: "registration.resonai.com")!,
                    port: 443
                ),
                app: .init(
                    clientID: FirebaseApp.app()?.options.clientID ?? "",
                    siteIDs: [],
                    shouldShowCloseButton: true,
                    hideHeader: false
                ),
                auth: .init(username: nil),
                language: .en
            )
        )

        Vera.useEventHandler { [weak self] event in
            switch event {
            case let .handleMessage(sender: sender, data: data):
                print("Sender: \(sender) -> \(data)")
            case .login:
                self?.login()
            case .logout:
                self?.logout()
            case .refreshToken:
                self?.renewAuthToken(forcingRefresh: true)
            @unknown default:
                fatalError()
            }
        }
    }

    private func renewAuthToken(forcingRefresh: Bool) {
        guard let user = Auth.auth().currentUser else {
            return login()
        }
        user.getIDTokenForcingRefresh(forcingRefresh) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                if AuthErrorCode(_nsError: error as NSError).code == .networkError {

                    // we let the SDK know we're offline when a network error occurs
                    Vera.handleEvent(.updateToken(.offline))
                }
                return
            }
            let currentUserId = Auth.auth().currentUser?.uid ?? ""

            // There either is a token or there isn't, in any case we let the SDK know
            Vera.handleEvent(.updateToken(idToken.map { .loggedIn(token: $0, userID: currentUserId) } ?? .anonymous))
        }
    }

    private func login() {
        // Show default Firebase auth controller on top of the Vera screen
        guard let viewController, let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        viewController.present(authUI.veraAuthController(), animated: true, completion: nil)
    }

    private func logout() {
        do {
            try FUIAuth.defaultAuthUI()?.signOut()
        } catch {
            print("ERROR: \(error)")
        }
    }
}

// MARK: - FUIAuthDelegate

extension VeraService: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error {
            return print("FUIAuthError: \(error.localizedDescription)")
        }
        if authDataResult != nil, viewController != nil {
            renewAuthToken(forcingRefresh: false)
        }
    }
}

extension FUIAuth {
    func veraAuthController() -> UIViewController {
        providers = [
            FUIGoogleAuth(authUI: FUIAuth.defaultAuthUI()!),
            FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!),
            FUIOAuth.appleAuthProvider(),
            FUIOAuth.microsoftAuthProvider()
        ]
        return authViewController()
    }
}
