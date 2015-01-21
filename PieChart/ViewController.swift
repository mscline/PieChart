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

        // INSTANCE VARIABLES

        //var arrayOfPieSlices:[PieSlice]?
    let lineWidth:Float = 2.0




    override func viewDidLoad() {
        super.viewDidLoad()


        let view = createUIViewWithEmbeddedPieChart(arrayOfPieSlices:createSampleData(), desiredHeightAndWidthOfView:200)
        self.view.addSubview(view)
        view.backgroundColor = UIColor.grayColor()

    }

    func createSampleData()->(Array<PieSlice>){

        let a = PieSlice(titleForLegend: "a", colorOfPieSlice: UIColor.blueColor(), positionOfPieSlice_indexNumber: 0, theTotal: 90)
        let b = PieSlice(titleForLegend: "b", colorOfPieSlice: UIColor.purpleColor(), positionOfPieSlice_indexNumber: 0, theTotal: 30)
        let c = PieSlice(titleForLegend: "c", colorOfPieSlice: UIColor.brownColor(), positionOfPieSlice_indexNumber: 0, theTotal: 30)
        let c2 = PieSlice(titleForLegend: "c", colorOfPieSlice: UIColor.redColor(), positionOfPieSlice_indexNumber: 0, theTotal: 30)
        let d = PieSlice(titleForLegend: "d", colorOfPieSlice: UIColor.greenColor(), positionOfPieSlice_indexNumber: 0, theTotal: 100)
        let d2 = PieSlice(titleForLegend: "d", colorOfPieSlice: UIColor.yellowColor(), positionOfPieSlice_indexNumber: 0, theTotal: 40)

        // add to array
        var arrayOfPieSlicesToDisplay:[PieSlice] = Array()

        arrayOfPieSlicesToDisplay.append(a)
        arrayOfPieSlicesToDisplay.append(b)
        arrayOfPieSlicesToDisplay.append(c)
        arrayOfPieSlicesToDisplay.append(c2)
        arrayOfPieSlicesToDisplay.append(d)
        arrayOfPieSlicesToDisplay.append(d2)

        return arrayOfPieSlicesToDisplay

    }

    // MARK: CREATE PIE CHART

    func createUIViewWithEmbeddedPieChart(#arrayOfPieSlices:Array<PieSlice>!, desiredHeightAndWidthOfView:CGFloat)->(UIView){

        let view = UIView(frame: CGRectMake(0, 0, desiredHeightAndWidthOfView, desiredHeightAndWidthOfView))

        // make sure pie slices sorted properly
//        let sortedArray = arrayOfPieSlices.sorted { (a, b) -> Bool in
//
//            return a.indexNumberTellingOrderToDisplayPiePieces < b.indexNumberTellingOrderToDisplayPiePieces
//        }

        // calculate total value of all pie slices
        let total = addupTotalValueOfAllPieSlices(arrayOfPiceSlices: arrayOfPieSlices)

        // for each pie slice
        var startAtAngle_inRadians:Float = 0

        for slice in arrayOfPieSlices {

            let desiredHeightAndWidthOfView_float = Float(desiredHeightAndWidthOfView)
            let pieTotalValue = Float(slice.theTotal)
            let angleOfPie = (pieTotalValue / total) * 2 * 3.14159

            let sliceOfPie = createSliceOfPie(heightAndWidthOfView:desiredHeightAndWidthOfView_float, startAngleInRadians: startAtAngle_inRadians, angleInRadians: angleOfPie, color:slice.colorOfPieSlice)
            view.layer.addSublayer(sliceOfPie)

            startAtAngle_inRadians = startAtAngle_inRadians + angleOfPie

        }

        return view
    }

    func addupTotalValueOfAllPieSlices(#arrayOfPiceSlices:Array<PieSlice>)->(Float){

        var total:Float = 0.0

        for slice in arrayOfPiceSlices {

            total = total + slice.theTotal.floatValue
        }

        return total
    }

    func createSliceOfPie(#heightAndWidthOfView:Float, startAngleInRadians:Float, angleInRadians:Float, color:UIColor)->(CAShapeLayer){


        // APPLE DRAWS THE UNIT CIRCLE BACKWARDS, SO FLIP SIGNS
        var startAngle_inRadians = -startAngleInRadians

        // MAKE BASIC CALCULATIONS FOR OUR CIRCLE
        let radius = (heightAndWidthOfView - lineWidth)/2
        let finalAngle = startAngle_inRadians - angleInRadians  // FLIP SIGN

        let xCoordPointOnArc = heightAndWidthOfView/2 + radius * cosf(startAngle_inRadians)
        let yCoordPointOnArc = heightAndWidthOfView/2 + radius * sinf(startAngle_inRadians)

        // convert floats to CGFloats (arrggghhh...)
        let xCoordPointOnArc_cgfloat = CGFloat(xCoordPointOnArc)
        let yCoordPointOnArc_cgfloat = CGFloat(yCoordPointOnArc)
        let startAngle_cgfloat = CGFloat(startAngle_inRadians)
        let finalAngle_cgfloat = CGFloat(finalAngle)
        let angle_cgfloat = CGFloat(angleInRadians)

        // create additional variables to work with
        let radius_cgfloat = CGFloat(radius)
        let center_cgFloat = CGPointMake(CGFloat(heightAndWidthOfView/2), CGFloat(heightAndWidthOfView/2))
        let xyCoordPointOnArc = CGPointMake(xCoordPointOnArc_cgfloat, yCoordPointOnArc_cgfloat)


        // CREATE LAYER
        let shapeLayer = CAShapeLayer()

        // set color and line settings
        shapeLayer.fillColor = color.CGColor
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.lineWidth = 2.0


        // BUILD SHAPE FROM LINE SEGEMENTS (ie a Bezier Path)
        let connectedLineSegments = UIBezierPath()

            // 1) set start point = center
            connectedLineSegments.moveToPoint(center_cgFloat)

            // 2) connect with point on our circle
            connectedLineSegments.addLineToPoint(xyCoordPointOnArc)

            // 3) draw arc
            connectedLineSegments.addArcWithCenter(center_cgFloat, radius:radius_cgfloat, startAngle:startAngle_cgfloat, endAngle: finalAngle_cgfloat, clockwise: false)

            // 4) draw line from last point back to the center
            connectedLineSegments.closePath()  // rather than calling addLine, we could use close path which will draw a line to connect our line with our start point


        // use our Bezier Path as a mask
        shapeLayer.path = connectedLineSegments.CGPath

        return shapeLayer
    }

    // MARK: CODING

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}




