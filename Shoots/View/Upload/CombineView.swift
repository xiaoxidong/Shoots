//
//  CombineView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct CombineView: View {
    @State var selected = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            ForEach(1..<5, id: \.self) { index in
                Image("s\(index)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 560)
                    .overlay {
                        Group {
                            Color.red
                                .opacity(0.06)
                                .border(Color.red, width: 1)
                            VStack {
                                clipButton(top: true)
                                Spacer()
                                clipButton(top: false)
                            }
                        }.opacity(selected == "s\(index)" ? 1 : 0)
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selected = "s\(index)"
                        }
                    }
            }.frame(maxWidth: .infinity)
        }
        .navigationTitle("点击图片进行裁剪")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("保存")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
            }
    }
    
    func clipButton(top: Bool) -> some View {
        ZStack {
            Rectangle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round, miterLimit: 4.0, dash: [15.0], dashPhase: 0.0))
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
            HStack(spacing: 0) {
                Image("left")
                    .offset(x: -15)
                    .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
                Spacer()
                Image("right")
                    .offset(x: 15)
                    .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
            }
        }.offset(y: top ? -15 : 15)
    }
}

struct CombineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CombineView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
