//
//  LoginView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/5/20.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @Binding var login: Bool
    let successAction: () -> Void
    
    @EnvironmentObject var user: UserViewModel
    var body: some View {
        Group {
            Color.black.opacity(login ? 0.02 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        login.toggle()
                    }
                }
            VStack {
                Spacer()
                VStack(spacing: 22) {
                    Text("登录应用")
                    
                    SignInWithAppleButton(onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }, onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Authorization successful.")
                            guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential, let identityToken = credentials.identityToken, let identityTokenString = String(data: identityToken, encoding: .utf8) else { return }
                            
                            let email = credentials.email
                            let userID = credentials.user
                            
                            let firstName = credentials.fullName?.givenName
                            let lastName = credentials.fullName?.familyName
                            
                            user.login(appleUserId: userID, identityToken: identityTokenString, email: email, fullName: "\(firstName ?? "") \(lastName ?? "")") { success in
                                withAnimation(.spring()) {
                                    login.toggle()
                                }
                                if !success {
                                    // 提示登录失败
                                }
                            }
                        case .failure(let error):
                            print("Authorization failed: " + error.localizedDescription)
                            withAnimation(.spring()) {
                                login.toggle()
                                // 提示登录失败
                                
                            }
                        }
                    }).frame(height: 46)
                        .signInWithAppleButtonStyle(.black)
                        .cornerRadius(26)
                }.frame(maxWidth: .infinity)
                    .padding()
                    .padding(.bottom)
                    .padding(.top, 8)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.shootBlack.opacity(0.2), radius: 10, y: -10)
                .contentShape(Rectangle())
                .offset(y: login ? 0 : 1000)
            }.frame(maxWidth: 460)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(login: .constant(true)) {
            
        }
    }
}
