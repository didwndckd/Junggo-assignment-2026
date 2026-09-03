//
//  EmptyStateView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct EmptyStateView: View {
    private let message: String

    init(message: String) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#if DEBUG
#Preview {
    EmptyStateView(message: "표시할 항목이 없어요")
}
#endif
