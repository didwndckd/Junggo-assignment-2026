//
//  ErrorStateView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct ErrorStateView: View {
    private let message: String
    private let retryAction: () async -> Void

    init(message: String, retryAction: @escaping () async -> Void) {
        self.message = message
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("다시 시도") {
                Task {
                    await retryAction()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

#if DEBUG
#Preview {
    ErrorStateView(message: "상품을 불러오지 못했어요") { }
}
#endif
