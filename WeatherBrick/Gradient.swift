import Foundation
import UIKit


extension UIButton {
    func setGradientLayer(colorsInOrder colors: [CGColor], startPoint sPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint ePoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        self.contentVerticalAlignment = .top
        self.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 0.0, right: 0.0)
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        let gLayer = CAGradientLayer()
        gLayer.frame = self.bounds
        gLayer.colors = colors
        gLayer.startPoint = sPoint
        gLayer.endPoint = ePoint
        
        gLayer.cornerRadius = 5
        
        gLayer.shadowOpacity = 0.6
        gLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        layer.insertSublayer(gLayer, at: 0)
    }
}

