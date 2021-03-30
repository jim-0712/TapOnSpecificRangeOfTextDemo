//
//  File.swift
//  TapOnSpecificRangeOfTextDemo
//
//  Created by Fu Jim on 2021/3/15.
//

import UIKit
import Foundation

struct People {
    let name: String
    let bodyShape: [BodyShape]?
}

struct BodyShape {
    let height: String
    let weight: String
}

let demo1: [People] = [People(name: "Jim", bodyShape: [BodyShape(height: "180", weight: "170")]),
                       People(name: "Irene", bodyShape: [BodyShape(height: "150", weight: "12345678987654321"),
                                                         BodyShape(height: "160", weight: "60")])]


//let demo2: [People] = [People(name: "Jim", bodyShape: BodyShape(height: 180, weight: 70)),
//                       People(name: "Amy", bodyShape: nil),
//                       People(name: "Irene", bodyShape: BodyShape(height: 160, weight: 50)),
//                       People(name: "Luke", bodyShape: BodyShape(height: 180, weight: 70)),
//                       People(name: "Neal", bodyShape: nil),
//                       People(name: "Chris", bodyShape: BodyShape(height: 160, weight: 50))]
