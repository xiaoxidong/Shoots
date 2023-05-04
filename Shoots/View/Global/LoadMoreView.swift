//
//  LoadMoreView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/29.
//

import SwiftUI
import Refresh

struct LoadMoreView: View {
    @Binding var footerRefreshing: Bool
    @Binding var noMore: Bool
    let action: () -> Void
    
    var body: some View {
        // 上拉加载更多
        RefreshFooter(refreshing: $footerRefreshing, action: action) {
            if self.noMore {
                Text("全部内容都展示完了")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootGray)
            } else {
                #if os(iOS)
                DNALoading()
                    .padding(.top, 36)
                    .padding(.bottom)
                #else
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.small)
                    Text("加载中...")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.shootBlack)
                }
                #endif
            }
        }
        .noMore(noMore)
        .preload(offset: 50)
    }
    
    
}

struct LoadMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LoadMoreView(footerRefreshing: .constant(true), noMore: .constant(false)) {
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        LoadMoreView(footerRefreshing: .constant(true), noMore: .constant(false)) {
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
