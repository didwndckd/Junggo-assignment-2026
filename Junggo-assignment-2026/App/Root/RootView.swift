//
//  RootView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct RootView: View {
    private let root: CompositionRoot
    @Bindable private var router: Router
    
    init() {
        let root = CompositionRoot()
        self.root = root
        self.router = root.router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ProductListView(viewModel: root.productListViewModel)
                .navigationDestination(for: Route.self) { route in
                    root.view(from: route)
                }
        }
    }
}

#if DEBUG
#Preview {
    RootView()
}
#endif
