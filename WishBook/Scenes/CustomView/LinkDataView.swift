//
//  LinkDataView.swift
//  WishBook
//
//  Created by Vadym on 21.06.2021.
//

import SwiftUI
import LinkPresentation

struct LinkDataView: UIViewRepresentable {
    typealias UIViewType = LinkContainerView

    @Binding var urlString: String

    func makeUIView(context: UIViewRepresentableContext<LinkDataView>) -> LinkDataView.UIViewType {
        let linkContainerView = LinkContainerView()
        linkContainerView.linkViewIsHidden(true)
        return linkContainerView
    }

    func updateUIView(_ uiView: LinkDataView.UIViewType, context: UIViewRepresentableContext<LinkDataView>) {
        guard let safeUrl = URL(string: urlString) else { return }
        if let cachedData = MetaCache.retrieve(urlString: safeUrl.absoluteString) {
            uiView.setMetadata(cachedData)
            uiView.linkViewIsHidden(false)
        } else {
            let provider = LPMetadataProvider()

            provider.startFetchingMetadata(for: safeUrl) { metadata, error in
                guard let metadata = metadata, error == nil else { return }

                MetaCache.cache(metadata: metadata)

                DispatchQueue.main.async {
                    uiView.setMetadata(metadata)
                    uiView.linkViewIsHidden(false)
                }
            }
        }
    }
}
