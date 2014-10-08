//
//  BFImageView.swift
//  bfswift
//
//  Created by croath on 6/4/14.
//  Copyright (c) 2014 croath. All rights reserved.
//
//
import Foundation
import UIKit
import QuartzCore

let BETTER_LAYER_NAME = "BETTER_LAYER_NAME"
let GOLDEN_RATIO = 0.618

class BFImageView: UIImageView {
    var needsBetterFace: Bool = false
    
    var fast: Bool = true
    
    var detector: CIDetector?
    
    override var image: UIImage! {
    get {
        return super.image
    }
    set {
        super.image = newValue
        if self.needsBetterFace {
            self.faceDetect(newValue)
        }
    }
    }
    
    func faceDetect(aImage: UIImage){
        var queue: dispatch_queue_t = dispatch_queue_create("com.croath.betterface.queue", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(queue,
            {
                var image = aImage.CIImage
                if image == nil {
                    image = CIImage(CGImage: aImage.CGImage)
                }
                
                if self.detector == nil {
                    var opts = [(self.fast ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh): CIDetectorAccuracy]
                    self.detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: opts)
                }
                
                var features: [AnyObject] = self.detector!.featuresInImage(image)
                
                if features.count == 0 {
                    println("no faces")
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            self.imageLayer().removeFromSuperlayer()
                        })
                } else {
                    println("succeed \(features.count) faces")
                    var imgSize = CGSize(width: Double(CGImageGetWidth(aImage.CGImage)), height: (Double(CGImageGetHeight(aImage.CGImage))))
                    self.markAfterFaceDetect(features, size: imgSize)
                }
            })
    }
    
    func markAfterFaceDetect(features: [AnyObject], size: CGSize) {
        var fixedRect = CGRect(x: Double(MAXFLOAT), y: Double(MAXFLOAT), width: 0, height: 0)
        var rightBorder:Double = 0, bottomBorder: Double = 0
        for f: AnyObject in features {
            var oneRect = CGRectMake(f.bounds.origin.x, f.bounds.origin.y, f.bounds.size.width, f.bounds.size.height)
            oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height
            
            fixedRect.origin.x = min(oneRect.origin.x, fixedRect.origin.x)
            fixedRect.origin.y = min(oneRect.origin.y, fixedRect.origin.y)
            
            rightBorder = max(Double(oneRect.origin.x) + Double(oneRect.size.width), rightBorder)
            bottomBorder = max(Double(oneRect.origin.y) + Double(oneRect.size.height), bottomBorder)
        }
        
        fixedRect.size.width = CGFloat(Int(rightBorder) - Int(fixedRect.origin.x))
        fixedRect.size.height = CGFloat(Int(bottomBorder) - Int(fixedRect.origin.y))
        
        var fixedCenter: CGPoint = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
            fixedRect.origin.y + fixedRect.size.height / 2.0)
        var offset: CGPoint = CGPointZero
        var finalSize: CGSize = size
        if size.width / size.height > self.bounds.size.width / self.bounds.size.height {
            //move horizonal
            finalSize.height = self.bounds.size.height
            finalSize.width = size.width/size.height * finalSize.height
            fixedCenter.x = finalSize.width / size.width * fixedCenter.x
            fixedCenter.y = finalSize.width / size.width * fixedCenter.y
            
            offset.x = fixedCenter.x - self.bounds.size.width * 0.5
            if (offset.x < 0) {
                offset.x = 0
            } else if (offset.x + self.bounds.size.width > finalSize.width) {
                offset.x = finalSize.width - self.bounds.size.width
            }
            offset.x = -offset.x
        } else {
            //move vertical
            finalSize.width = self.bounds.size.width
            finalSize.height = size.height/size.width * finalSize.width
            fixedCenter.x = finalSize.width / size.width * fixedCenter.x
            fixedCenter.y = finalSize.width / size.width * fixedCenter.y
            
            offset.y = CGFloat(fixedCenter.y - self.bounds.size.height * CGFloat(1-GOLDEN_RATIO))
            if (offset.y < 0) {
                offset.y = 0
            } else if (offset.y + self.bounds.size.height > finalSize.height){
                finalSize.height = self.bounds.size.height
                offset.y = finalSize.height
            }
            offset.y = -offset.y
        }
        
        dispatch_async(dispatch_get_main_queue(),
            {
                var layer: CALayer = self.imageLayer()
                layer.frame = CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height)
                layer.contents = self.image.CGImage
            })
    }
    
    func imageLayer() -> CALayer {
        if let sublayers = self.layer.sublayers {
            for layer: AnyObject in sublayers {
                if layer.name == BETTER_LAYER_NAME {
                    return layer as CALayer
                }
            }
        }
        
        var layer = CALayer()
        layer.name = BETTER_LAYER_NAME
        layer.actions =
            [
                "contents": NSNull(),
                "bounds": NSNull(),
                "position": NSNull()
        ]
        self.layer.addSublayer(layer)
        return layer
    }
}
