//
//  CollectionViewEmbed.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import SwiftUI

open class CollectionViewEmbed<Content>: UICollectionViewCell where Content: View {
    private(set) var controller: UIHostingController<Content>?
    func embed(in parent: UIViewController, withView content: Content) {
        if let controller = self.controller {
            controller.rootView = content
            controller.view.layoutIfNeeded()
        } else {
            let controller = UIHostingController(rootView: content)
            parent.addChild(controller)
            controller.didMove(toParent: parent)
            self.contentView.addSubview(controller.view)
            self.controller = controller
        }
    }
    deinit {
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        controller = nil
    }
}
