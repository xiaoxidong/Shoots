//
//  ContentView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Ellipse()
                .frame(width: 36, height: 36)
                
            HomeView()
        }
        .padding()
        .onAppear {
            // 首页新手引导的逻辑
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
