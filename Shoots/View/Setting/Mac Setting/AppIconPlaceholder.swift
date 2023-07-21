//
//  AppIconPlaceholder.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct AppIconPlaceholder: View {
    private let cornerSize: CGSize = .init(width: 24.0, height: 24.0)
    var body: some View {
        return RoundedRectangle(cornerSize: self.cornerSize, style: .continuous)
            .foregroundColor(Color.secondary)
            .padding(13.0)
    }
}

struct AppIconPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPlaceholder()
    }
}
