//
//  SuperRefreshControl.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 21.04.2022.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {
    
    weak var swipeRefreshDelegate: RefreshControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(onSwipeRefresh(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSwipeRefresh(_ sender: UIRefreshControl) {
        swipeRefreshDelegate?.onSwipeRefresh()
        beginRefreshingManually()
    }
    
    func isLoading(_ isLoading: Bool) {
        if isLoading {
            beginRefreshingManually()
            print("loading")
        }
    }
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        self.beginRefreshing()
    }
}

protocol RefreshControlDelegate: AnyObject {
    func onSwipeRefresh()
}
