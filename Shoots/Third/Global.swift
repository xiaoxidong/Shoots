//
//  Global.swift
//  Notes
//
//  Created by XiaoDong Yuan on 5/10/2022.
//

import SwiftUI

#if os(iOS)
    let bottomPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    let topPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
#endif

let freeDays = 10
let keyChain = Keychain()
let daysLeft = (freeDays - Int((keyChain["DownloadDay"]?.toDate() ?? DateInRegion())!.getInterval(toDate: DateInRegion(), component: .day))) > 0 ? (freeDays - Int((keyChain["DownloadDay"]?.toDate() ?? DateInRegion())!.getInterval(toDate: DateInRegion(), component: .day))) : 0
