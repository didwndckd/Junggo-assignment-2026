//
//  WishButton.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct WishButton: View {
    private let isWished: Bool
    private let action: () async -> Void

    init(isWished: Bool, action: @escaping () async -> Void) {
        self.isWished = isWished
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(systemName: isWished ? "heart.fill" : "heart")
                .foregroundStyle(isWished ? .red : .secondary)
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
private struct WishButtonPreviewContainer: View {
    @State private var isWished = false

    var body: some View {
        WishButton(isWished: isWished) {
            isWished.toggle()
        }
    }
}

#Preview {
    WishButtonPreviewContainer()
}
#endif
