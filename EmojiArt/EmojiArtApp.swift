//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Alexandre Papanis on 10/26/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
