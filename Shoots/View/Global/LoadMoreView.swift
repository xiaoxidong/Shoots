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
                DNALoading()
                    .padding(.top, 36)
                    .padding(.bottom)
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
    }
}
