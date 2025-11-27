//
//  AppState.swift
//  ReclaimLostandFound
//
//  Created by csuftitan on 11/26/25.
//

import SwiftUI
internal import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
