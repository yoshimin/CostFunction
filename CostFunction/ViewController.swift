//
//  ViewController.swift
//  CostFunction
//
//  Created by SHINGAI YOSHIMI on 2019/05/15.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let shapelayer = CAShapeLayer()
    private let radius: CGFloat = 2
    private var samples: [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(shapelayer)
    }


}

// MARK: - Private
private extension ViewController {
    @IBAction func handleTap(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)

        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(x: location.x - radius, y: location.y - radius, width: radius*2, height: radius*2)).cgPath
        layer.strokeColor = UIColor.red.cgColor
        shapelayer.addSublayer(layer)

        samples.append(CGPoint(x: location.x, y: view.frame.height - location.y))
    }

    @IBAction func stroke() {
        let x = samples.map{$0.x}
        let y = samples.map{$0.y}
        let m = samples.count

        // 平均
        let plus = { (a: CGFloat, b: CGFloat) -> CGFloat in a + b }
        let aveX = x.reduce(0, plus)/CGFloat(m)
        let aveY = y.reduce(0, plus)/CGFloat(m)

        // 分散
        let s_xy = zip(x.map{$0-aveX}, y.map{$0-aveY}).map(*).reduce(0, plus)/CGFloat(m)
        let s_x = x.map{pow($0-aveX, 2)}.reduce(0, plus)/CGFloat(m)

        // 回帰係数
        let a = s_xy/s_x

        // 切片
        let b = aveY-a*aveX

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: view.frame.height - b))
        path.addLine(to: CGPoint(x: view.frame.width, y: view.frame.height - (a*view.frame.width+b)))
        path.close()
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.blue.cgColor
        shapelayer.addSublayer(layer)
    }

    @IBAction func reset() {
        shapelayer.sublayers?.forEach { layer in
            layer.removeFromSuperlayer()
        }
        samples.removeAll()
    }
}
