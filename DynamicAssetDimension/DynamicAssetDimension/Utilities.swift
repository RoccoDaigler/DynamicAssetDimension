//
//  Utilities.swift
//  DynamicAssetDimension
//
//  Created by James Daigler on 10/24/20.
//

import Foundation
import ARKit

func getAverage(x: Float, y: Float) -> Float {
    return (x + y) / 2
}
func getScale(originalMeasurement: Float, newMeasurement: Float) -> Float {
    return newMeasurement / originalMeasurement
}

func getMiddle(n1: Float, n2: Float) -> Float{
    return (n1 + n2) / 2
}
func calculateDistance3D(start: SCNNode, end: SCNNode) -> Float {
    //3d pythagoras
    //√(a^2 + b^2 + c^2)
    let a = end.position.x - start.position.x
    let b = end.position.y - start.position.y
    let c = end.position.z - start.position.z
    
    let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
    
    return abs(distance)
}
