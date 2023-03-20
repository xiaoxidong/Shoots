//
//  ContentView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeVM: HomeViewModel = HomeViewModel()
    @State var searchText: String = ""
    var body: some View {
        NavigationView {
            HomeView(homeVM: homeVM)
                .navigationTitle("Shoots")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink {
                            SelfView()
                        } label: {
                            Image("self")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SelfView()
                        } label: {
                            Image("upload")
                        }
                    }
                }
        }.onAppear {
            // 请求第一页的数据
            loadData()
        }
    }
    
    
    // MARK: - 首页方法
    func loadData() {
        homeVM.getData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
