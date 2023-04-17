//
//  ContentView.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOSApplicationExtension 13.0, *) {
            Text("Hello, World!")
        } else {
            Text("Hello, World!")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
