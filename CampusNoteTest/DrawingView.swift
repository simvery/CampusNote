//
//  DrawingView.swift
//  CampusNoteTest
//
//  Created by user on 2017. 11. 24..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class DrawingView: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var lastpoint: CGPoint!
    var lineSize:CGFloat = 2.0
    var lineColor = UIColor.black.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearImageView(_ sender: Any) {
        imgView.image = nil
    }
    
    @IBAction func Delete(_ sender: Any) {

    }
    
    @IBAction func Save(_ sender: Any) {
        /*
        let MemoNumber = UserDefaults.standard.object(forKey: "MemoNumber") as! Int
        if MemoNumber == -1 {
            ArtData.insert(imgView.image!, at: 0)
            UserDefaults.standard.set(ArtData, forKey: "ArtData")
        } else {
            ArtData.remove(at: MemoNumber)
            ArtData.insert(imgView.image!, at: MemoNumber)
            UserDefaults.standard.set(ArtData, forKey: "ArtData")
        }
        */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        lastpoint = touch.location(in: imgView)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(imgView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        let touch = touches.first! as UITouch
        let currPoint = touch.location(in: imgView)
        
        imgView.image?.draw(in: CGRect(x:0, y:0, width: imgView.frame.size.width, height: imgView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastpoint.x, y: lastpoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastpoint = currPoint
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(imgView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        imgView.image?.draw(in: CGRect(x: 0,y: 0, width: imgView.frame.size.width, height: imgView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastpoint.x, y: lastpoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastpoint.x, y:lastpoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func ColorList(_ sender: Any) {
        let aIertController = UIAlertController(title: "Hello", message: "What do you want to do?", preferredStyle: .actionSheet)
        
        let black = UIAlertAction(title: "Black", style: .default) { (action: UIAlertAction) in
            self.lineColor = UIColor.black.cgColor
        }
        
        let red = UIAlertAction(title: "Red", style: .default) { (action: UIAlertAction) in
            self.lineColor = UIColor.red.cgColor
        }
        
        let green = UIAlertAction(title: "Green", style: .default) { (action: UIAlertAction) in
            self.lineColor = UIColor.green.cgColor
        }
        
        let blue = UIAlertAction(title: "Blue", style: .default) { (action: UIAlertAction) in
            self.lineColor = UIColor.blue.cgColor
        }
        
        
        aIertController.addAction(black)
        aIertController.addAction(red)
        aIertController.addAction(green)
        aIertController.addAction(blue)
        present(aIertController, animated: true, completion: nil)
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            imgView.image = nil
            
        }
    }
}

