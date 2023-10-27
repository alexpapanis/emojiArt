//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by Alexandre Papanis on 10/27/23.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}
