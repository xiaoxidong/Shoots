//
//  UploadingIndicatorView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/15.
//

import SwiftUI

struct UploadingIndicatorView: View {
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.6)
            .stroke(Color.black, lineWidth: 2)
    }
}

struct UploadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        UploadingIndicatorView()
    }
}
