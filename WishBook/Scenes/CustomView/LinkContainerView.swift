//
//  LinkContainerView.swift
//  WishBook
//
//  Created by Вадим on 22.06.2021.
//

import UIKit
import LinkPresentation

final class LinkContainerView: UIView {
    private lazy var linkView: LPLinkView = {
        $0.frame = self.bounds
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(LPLinkView())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupView() {
        self.addSubview(linkView)
    }

    func setMetadata(_ metaData: LPLinkMetadata) {
        linkView.metadata = metaData
    }

    func linkViewIsHidden(_ isHidden: Bool) {
        linkView.isHidden = isHidden
    }
}
