//
//  ProductThumbnailView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Kingfisher
import SwiftUI

struct ProductThumbnailView: View {
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    var body: some View {
        Group {
            if let url {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        placeholder
                    }
                    .fade(duration: 0.2)
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.quaternary)
        }
    }
}

private extension ProductThumbnailView {
    var placeholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.quaternary)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
    }
}
