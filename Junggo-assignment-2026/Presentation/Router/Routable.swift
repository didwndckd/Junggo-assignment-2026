//
//  Routable.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Foundation

@MainActor
protocol Routable {
    func push(route: Route)
    func pop()
}
