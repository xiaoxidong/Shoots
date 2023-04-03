//
//  AddsView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct AddsView: View {
    @State var showAdds = false
    var body: some View {
        Color.red
            .frame(height: 200)
            .onTapGesture {
                showAdds.toggle()
            }
            .sheet(isPresented: $showAdds) {
                Color.red
                    .sheetFrameForMac()
            }
    }
}

struct AddsView_Previews: PreviewProvider {
    static var previews: some View {
        AddsView()
    }
}
