//
//  UIView_Activity.swift
//  MobCast
//
//  Created by user on 01.10.15.
//
//

import UIKit
import ObjectiveC

extension UIView {
    fileprivate struct AssociatedKey {
        static var activity = "activityRuntimeKey"
    }
    
    var activity: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.activity) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.activity, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivity() {
        if activity == nil {
            activity = UIActivityIndicatorView(frame: self.bounds)
            activity!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            activity!.backgroundColor = UIColor(white: 0, alpha : 0.1)
            activity!.style = .gray
        }
        activity!.frame = self.bounds
        activity!.startAnimating()
        self.addSubview(activity!)
    }
    
    func showActivityGray() {
        self.showActivity()
        activity!.backgroundColor = UIColor(white: 0, alpha : 0.2)
    }
    
    func showActivityWhite() {
        self.showActivity()
        activity?.style = .whiteLarge
    }
    
    func hideActivity() {
        activity?.removeFromSuperview()
    }
}
