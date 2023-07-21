//
//  LoginView.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/5/30.
//

import SwiftUI

struct LoginView: View {
    @Binding var login: Bool
    let successAction: () -> Void

    var body: some View {
        Text("打开应用登录")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(login: .constant(true)) {}
    }
}
