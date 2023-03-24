//
//  CombineView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct CombineSelectView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                editView
            }
            .navigationTitle("选择图片进行拼接")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CombineView()
                    } label: {
                        Text("拼接")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }.disabled(selected.isEmpty)
                }
            }
        }
    }
    
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2),
        GridItem(.flexible(minimum: 100, maximum: 160), spacing: 2)
    ]
    @State var selected: [String] = []
    var editView: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(homeData) { shoot in
                    Button(action: {
                        //选择和取消选择截图
                        withAnimation(.spring()) {
                            if selected.contains(shoot.imageUrl), let index = selected.firstIndex(of: shoot.imageUrl) {
                                selected.remove(at: index)
                            } else {
                                selected.append(shoot.imageUrl)
                            }
                        }
                    }, label: {
                        Image(shoot.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, alignment: .top)
                            .overlay(alignment: .bottomLeading) {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(12)
                                    .foregroundColor(selected.contains(shoot.imageUrl) ? Color.shootRed : Color.white)
                                    .shadow(radius: 6)
                            }
                    })
                }
            }
        }
    }
}

struct CombineSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CombineSelectView()
    }
}
