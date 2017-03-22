//
//  CanvasViewController.swift
//  Codepath-Lab7
//
//  Created by Diana C on 3/21/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 220
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            self.trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            self.trayView.center = CGPoint(x: self.trayOriginalCenter.x, y: self.trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            
            if velocity.y < 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            } else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
        }
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } else if sender.state == .changed {
            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y +
                translation.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            newlyCreatedFace.isUserInteractionEnabled = true
        }
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        newlyCreatedFace = sender.view as! UIImageView
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] , animations: { () -> Void in
                self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFaceOriginalCenter.x + translation.x, y: self.newlyCreatedFaceOriginalCenter.y + translation.y)
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
    }
    
    func didRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation)
        sender.rotation = 0
    }
}
