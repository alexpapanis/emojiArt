//
//  UtilityExtensions.swift
//  EmojiArt
//
//  Created by Alexandre Papanis on 10/27/23.
//

import SwiftUI

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}

extension Set where Element: Identifiable {
    mutating func toggleMembership(of element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        } else {
            insert(element)
        }
    }
}

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

extension URL {
    var imageURL: URL {
        for query in query?.components(separatedBy: "&") ?? [] {
            let queryComponents = query.components(separatedBy: "=")
            if queryComponents.count == 2 {
                if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                    return url
                }
            }
        }
        return baseURL ?? self
    }
}

extension DragGesture.Value {
    var distance: CGSize { location - startLocation }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension CGPoint {
    static func -(lhs: Self, rhs: Self) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
    static func +(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    static func -(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }
    static func *(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
    }
    static func /(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x / rhs.width, y: lhs.y / rhs.height)
    }
    
    
}

extension Array where Element == NSItemProvider {
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            provider.loadObject(ofClass: theType) { object, error in
                if let value = object as? T {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            let _ = provider.loadObject(ofClass: theType) { object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
}
