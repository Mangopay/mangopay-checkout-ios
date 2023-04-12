//
//  File.swift
//  
//
//  Created by Elikem Savie on 30/10/2022.
//

#if os(iOS)
import UIKit
#endif

extension CALayer {

    public func roundCorners(_ corners: CACornerMask?, radius: CGFloat) {
        guard let corners = corners else {
            cornerRadius = radius
            return
        }
        if #available(iOS 11, *) {
            maskedCorners = corners
            cornerRadius = radius
        } else {
            var cornerMask = UIRectCorner()
            if corners.contains(.layerMinXMinYCorner) {
                cornerMask.insert(.topLeft)
            }
            if corners.contains(.layerMaxXMinYCorner) {
                cornerMask.insert(.topRight)
            }
            if corners.contains(.layerMinXMaxYCorner) {
                cornerMask.insert(.bottomLeft)
            }
            if corners.contains(.layerMaxXMaxYCorner) {
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.mask = mask
       }
    }

}
