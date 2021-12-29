
import UIKit
import Foundation

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var brickIm: UIImageView!
    
    @IBOutlet weak var upConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var downConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.updateLocation))
        swipeRecognizer.direction = .down
        brickIm.addGestureRecognizer(swipeRecognizer)
        brickIm.isUserInteractionEnabled = true
    }
    
    @objc
    private func updateLocation(sender: UISwipeGestureRecognizer) {
        handlePullRefresh()
    }

    func handlePullRefresh() {
        let originTopConstraint = upConstraint.constant
        let originDownConstraint = downConstraint.constant
        UIView.animate(withDuration: 0.3 , animations: {
            self.upConstraint.constant += 40
            self.downConstraint.constant -= 40
            self.view.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.3 , animations: {
                self.upConstraint.constant = originTopConstraint
                self.downConstraint.constant = originDownConstraint
                self.view.layoutIfNeeded()
            })
        })
    }

}
