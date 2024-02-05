//
//  CongratsView.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit

class CongratsView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var buttonAction: (() -> Void)?
    var resultText: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        ctaButton.addTarget(self, action: #selector(okayButton), for: .touchUpInside)
    }

    @objc func okayButton() {
        buttonAction?()
        ResultView.hide()
    }

    @IBAction func copyButtonAction(_ sender: Any) {
        UIPasteboard.general.string = resultText
//        copyLabel.isHidden = false
//
//        UIView.transition(with: copyLabel, duration: 5, options: .transitionCrossDissolve, animations: {
//            self.copyLabel.isHidden = true
//
//        })
        
        copyLabel.alpha = 0
        copyLabel.isHidden = false
        UIView.animate(withDuration: 1) {
            self.copyLabel.alpha = 1
            self.copyLabel.alpha = 0
        }
    }

    func renderLabel(
        title: String = "Payment Succesful",
        result: String,
        isSucessful: Bool = true
    ) {
        if isSucessful {
            titleLabel.text = title
            resultLabel.text = "Result: " + result
            self.resultText = result
        } else {
            titleLabel.text = "Payment Failed"
            imageView.image = UIImage(systemName: "xmark")
            resultLabel.isHidden = true
            
        }
    }

}
