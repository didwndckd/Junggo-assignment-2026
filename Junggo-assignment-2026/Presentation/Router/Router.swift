//
//  Router.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Foundation

@MainActor
@Observable
class Router: Routable {
    var path: [Route] = []
    
    func push(route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
