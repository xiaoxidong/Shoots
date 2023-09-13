//
//  SearchAppsView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/13.
//

import SwiftUI

struct SearchAppsView: View {
    let setNameAction: (String) -> Void
    let setIDAction: (String) -> Void
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                dismiss()
                setIDAction("s")
                setNameAction("asdasdas")
            }
    }
}

struct SearchAppsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAppsView { name in
            
        } setIDAction: { id in
            
        }
    }
}
