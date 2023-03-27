//
//  ImageCardView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct ImageCardView: View {
    var shoot: Shoot
    
    @AppStorage("homeModel") var homeModel = 0
    @State var showDetail: Bool = false
    var body: some View {
        Image(shoot.imageUrl)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .sheet(isPresented: $showDetail) {
                DetailView(shoot: shoot)
                    .sheetFrameForMac()
            }
            .onTapGesture {
                showDetail.toggle()
            }
            .highPriorityGesture (
                TapGesture(count: 2)
                    .onEnded {
                        if homeModel == 0 {
                            homeModel = 1
                        } else if homeModel == 1 {
                            homeModel = 2
                        } else {
                            homeModel = 0
                        }
                    }
            )
            .onDrag {
                #if os(iOS)
                let provider = NSItemProvider(object: UIImage(named: shoot.imageUrl) ?? UIImage())
                #else
                let provider = NSItemProvider(object: NSImage(named: shoot.imageUrl) ?? NSImage())
                #endif
                return provider
            }
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(shoot: singleShoot)
    }
}
