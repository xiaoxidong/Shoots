//
//  WaveView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/14.
//

import SwiftUI

struct WaveView: View {
    
    var waveColor: Color
    var waveHeight: Double = 0.01
    var progress: Double
    
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            WaveShape(offset: waveOffset, waveHeight: waveHeight, percent: Double(progress)/100)
                .fill(waveColor)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: CGFloat(waveHeight * 200)).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                }
            }
        }
    }
}


struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(waveColor: .yellow, progress: 0)
    }
}


fileprivate struct WaveShape: Shape {
    
    var offset: Angle
    var waveHeight: Double = 0.025
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let waveHeight = waveHeight * rect.height
        let yoffset = CGFloat(1.0 - percent) * (rect.height - 8 * waveHeight)
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 361)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 8) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}
