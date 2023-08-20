//
//  AuditCardView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/8/20.
//

import SwiftUI

struct AuditCardView: View {
    var audit: Audit
    let direction: LeftRight?
    
    var body: some View {
        ImageView(urlString: audit.compressedPicUrl, image: .constant(nil))
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 0)
            .padding()
            .overlay(
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.red)
                        .clipShape(Circle())
                        .opacity(direction == .right ? 1 : 0)
                        .offset(x: -40)
                    Spacer()
                    Image(systemName: "trash.fill")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.pink)
                        .clipShape(Circle())
                        .opacity(direction == .left ? 1 : 0)
                        .offset(x: 60)
                }
                , alignment: .top
            )
    }
}

struct AuditCardView_Previews: PreviewProvider {
    static var previews: some View {
        AuditCardView(audit: Audit(id: "", picUrl: "", fileName: "", fileSuffix: "", linkApplicationName: "", isOfficial: "", delFlag: "", isAudit: "", isReport: "", createTime: ""), direction: .left)
    }
}
