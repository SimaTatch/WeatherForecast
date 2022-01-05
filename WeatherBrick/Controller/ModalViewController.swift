
import Foundation
import UIKit

class ModalViewController: UIViewController {
        
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var hideBut: UIButton!
    @IBOutlet weak var infoDiscription: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc
    private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpUI() {
        infoView.backgroundColor = UIColor(cgColor: Colors.OrangeGrad)
        infoView.layer.cornerRadius = 15
        infoView.layer.shadowOpacity = 1
        infoView.layer.shadowColor = Colors.OrangeGradSec
        infoView.layer.shadowOffset = CGSize(width: 10.0, height: 0)
        
        hideBut.setTitleColor( UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1), for: .normal)
        hideBut.titleLabel?.font =  UIFont(name: "SFProText-Semibold", size: 15)
        hideBut.layer.cornerRadius = 15
        hideBut.layer.borderWidth = 1
        hideBut.layer.borderColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1).cgColor
  
        
        infoLabel.textColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 1)
        infoLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.02
        infoLabel.attributedText = NSMutableAttributedString(string: "info", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        
        infoDiscription.textColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 1)
        infoDiscription.font = UIFont(name: "SFProText-Semibold", size: 15)
        infoDiscription.numberOfLines = 0
        infoDiscription.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.68
        infoDiscription.attributedText = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is gone - no Internet", attributes: [NSAttributedString.Key.kern: -0.3, NSAttributedString.Key.paragraphStyle: paragraphStyle])

    }
    
    @IBAction func hideButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

