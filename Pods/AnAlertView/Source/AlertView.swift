//
//  AlertView.swift
//  CustomViews
//
//  Created by Mohamed Korany Ali on 11/25/19.
//  Copyright © 2019 Mohamed Korany Ali. All rights reserved.
//

import UIKit
public protocol AlertViewDelegate: class {
    func dismissButtonTapped(_ button: UIButton)
}
public class AlertView: ANCustomView {

   
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageAlert: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textBackgroundView: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    private weak var delegate: AlertViewDelegate?
           
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           setupView()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
           setupView()
       }
       
       
       private func setupView() {
        let bundle = Bundle(for: AlertView.self)
        let nib = UINib(nibName: "AlertView", bundle: bundle)
        nib.instantiate(withOwner: self , options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
           
           button.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
           
         //  textBackgroundView.layer.cornerRadius = 10
          // textBackgroundView.layer.masksToBounds = true
           
//           button.layer.cornerRadius = button.bounds.height / 2
//           button.layer.masksToBounds = true
           button.setTitle("Dismiss", for: .normal)
       }
    
       @objc func buttonWasPressed(_ sender: UIButton) {
           
           delegate?.dismissButtonTapped(sender)
           
           UIView.animate(withDuration: 0.3, animations: {
            self.AnimateViewWithSpringDuration(self.textBackgroundView, animationDuration: 2.00, springDamping: 0.25, springVelocity: 8.00)
           }) { (done) in
               self.removeFromSuperview()
           }
        
        
      //  self.removeFromSuperview()
        
       }
       
    func setup(message: String?, button name: String?, delegate: AlertViewDelegate? , image:UIImage?) {
           
           if let message = message {
               textLabel.text = message
           }
           
           if let name = name {
               button.setTitle(name, for: .normal)
           }
           
           if let delegate = delegate {
               self.delegate = delegate
           }
        
        if let image = image {
            imageAlert.image = image
        }else{
            if #available(iOS 13.0, *) {
                imageAlert.image = UIImage(systemName: "heart.fill")
            } 
        }
        
    }
    
    
    
    public static  func showAlert(message: String?, button text: String?, delegate: AlertViewDelegate? , container:UIViewController ,image: UIImage?) {
        let alert = AlertView(frame: container.view.bounds)
        
        alert.setup(message: message, button: text, delegate: delegate, image: image)
                
        container.view.addSubview(alert)
        
        //alert.addBlurArea(area: self.view.frame, style: .light)
        
       // alert.AnimateView()
        alert.AnimateViewWithSpringDurationWithLowDamping(container.view, animationDuration: 1.00, springVelocity: 9.00)
    }

    
}
