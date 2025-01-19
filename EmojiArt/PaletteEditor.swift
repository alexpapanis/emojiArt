//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Alexandre Papanis on 1/19/25.
//

import SwiftUI

struct PaletteEditor: View {
    
    @Binding var palette: Palette
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojisSection
        }
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd: String = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { _ , emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
                .uniqued
        }
    }
    
    var removeEmojisSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = palette.emojis.uniqued.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll { String($0) == emoji }
                            }
                        }
                }
            }
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
            .previewLayout(.fixed(width: 300.0, height: 350))
    }
}
