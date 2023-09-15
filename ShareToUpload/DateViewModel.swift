//
//  DateViewModel.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/9/15.
//

import SwiftUI

class DataViewModel: ObservableObject {
    @Published var images: [LocalImageData] = []
}

