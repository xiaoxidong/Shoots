//
//  LoginView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import _AuthenticationServices_SwiftUI
import SwiftUI

struct LoginView: View {
    @Binding var login: Bool
    var showBG: Bool = true
    let successAction: () -> Void

    @EnvironmentObject var user: UserViewModel
    var body: some View {
        if showBG {
            content.ignoresSafeArea()
        } else {
            contentWithoutBG
        }
    }

    var content: some View {
        Group {
            Color.black.opacity(login ? 0.02 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        login.toggle()
                    }
                }
            VStack {
                Spacer()
                VStack {
                    Text("登录应用")
                    button
                }.frame(maxWidth: .infinity)
                    .padding(.top)
                    .background(Color.shootWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
                    .contentShape(Rectangle())
                    .offset(y: login ? 0 : 1000)
            }.frame(maxWidth: 460)
        }
    }

    var contentWithoutBG: some View {
//        VStack {
//            Spacer()
//            button
//            .contentShape(Rectangle())
//            .offset(y: login ? 0 : 1000)
//        }.frame(maxWidth: 460)
        VStack {
            Spacer()
            VStack {
                Text("登录应用")
                button
            }.frame(maxWidth: .infinity)
                .padding(.top)
                .background(Color.shootWhite)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.shootBlack.opacity(0.1), radius: 10, y: -6)
                .contentShape(Rectangle())
                .offset(y: login ? 0 : 1000)
        }.frame(maxWidth: 460)
    }

    let url = URL(string: "https://productpoke.notion.site/Shoots-e6565357d2704e3694aa622a0d854b46")!
    var button: some View {
        Group {
            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                switch result {
                case let .success(authResults):
                    print("Authorization successful.")
                    guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential, let identityToken = credentials.identityToken, let identityTokenString = String(data: identityToken, encoding: .utf8) else { return }

                    let email = credentials.email
                    let userID = credentials.user

                    let firstName = credentials.fullName?.givenName
                    let lastName = credentials.fullName?.familyName

                    user.login(appleUserId: userID, identityToken: identityTokenString, email: email ?? "", fullName: "\(firstName ?? "") \(lastName ?? "")") { success in
                        withAnimation(.spring()) {
                            login.toggle()
                        }
                        if !success {
                            // 提示登录失败
                        }
                    }
                case let .failure(error):
                    print("Authorization failed: " + error.localizedDescription)
                    withAnimation(.spring()) {
                        login.toggle()
                        // 提示登录失败
                    }
                }
            })
            .signInWithAppleButtonStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .frame(height: 46)
            .padding(.horizontal)
            Button {
                #if os(iOS)
                    UIApplication.shared.open(url)
                #else
                    NSWorkspace.shared.open(url)
                #endif
            } label: {
                Text("注册即同意 ")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.shootBlack)
                    + Text("Shoots 使用协议")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.shootBlue)
            }.buttonStyle(.plain)
                .padding(.bottom, 36)
                .padding(.top, 4)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(login: .constant(true)) {}
    }
}
