//
//  ContentView.swift
//  iOSWidgetTest
//
//  Created on 2023/06/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var properties = Properties()

    var body: some View {
        VStack {
            Button(action: {
                properties.count += 1
            }, label: {
                Text("GroupUserDefaults.count add")
            })

            Text("\(properties.count)")
                .padding(.bottom)

            Button(action: {
                properties.count = 0
            }, label: {
                Text("GroupUserDefaults.count reset to 0")
            })
        }
        .padding()
    }
}

final class Properties: ObservableObject {
    @Published var count: Int = GroupUserDefaults.shared.count {
        didSet {
            GroupUserDefaults.shared.count = count
        }
    }
}

final class GroupUserDefaults {
    private static let groupIdentifier: String = "group." + (bundleIdentifier ?? "")
    private static let bundleIdentifier: String? = {
        let id = Bundle.main.bundleIdentifier
        if let range = id?.range(of: "iOSWidgetTest") {
            return String(id?[..<range.upperBound] ?? "")
        }
        return nil
    }()

    static let shared = GroupUserDefaults()

    private let userDefaults = UserDefaults(suiteName: groupIdentifier)!
}

extension GroupUserDefaults {
    var count: Int {
        get {
            return userDefaults.integer(forKey: "count")
        } set {
            userDefaults.set(newValue, forKey: "count")
        }
    }
}
