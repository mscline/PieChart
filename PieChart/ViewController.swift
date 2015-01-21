//
//  ViewController.swift
//  PieChart
//
//  Created by xcode on 1/21/15.
//  Copyright (c) 2015 MSCline. All rights reserved.
//


/*

http://blog.pixelingene.com/2012/02/animating-pie-slices-using-a-custom-calayer/

Use the standard Views and Controls in UIKit and create a view hierarchy
Use the UIAppearance protocol to customize standard controls
Use UIWebView and render some complex layouts in HTML + JS. This is a surprisingly viable option for certain kinds of views
Use UIImageView and show a pre-rendered image. This is sometimes the best way to show a complex graphic instead of building up a series of vectors. Images can be used more liberally in iOS and many of the standard controls even accept an image as parameter.
Create a custom UIView and override drawRect:. This is like the chain-saw in our toolbelt. Used wisely it can clear dense forests of UI challenges.
Apply masking (a.k.a. clipping) on vector graphics or images. Masking is often underrated in most toolkits but it does come very handy.
Use Core Animation Layers: CALayer with shadows, cornerRadius or masks. Use CAGradientLayer, CAShapeLayer or CATiledLayer
Create a custom UIView and render a CALayer hierarchy

*/

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


/*

-(CAShapeLayer *)createPieSlice {
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = [UIColor redColor].CGColor;
    slice.strokeColor = [UIColor blackColor].CGColor;
    slice.lineWidth = 3.0;

    CGFloat angle = DEG2RAD(-60.0);
    CGPoint center = CGPointMake(100.0, 100.0);
    CGFloat radius = 100.0;

    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];

    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];

    [piePath addArcWithCenter:center radius:radius startAngle:angle endAngle:DEG2RAD(60.0) clockwise:YES];

    //   [piePath addLineToPoint:center];
    [piePath closePath]; // this will automatically add a straight line to the center
    slice.path = piePath.CGPath;
    
    return slice;
}

*/

