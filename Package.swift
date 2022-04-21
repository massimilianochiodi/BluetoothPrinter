// swift-tools-version:5.3
//  Package.swift
//  BluetoothPrinter
//
//  Created by Chiodi Massimiliano
//

import PackageDescription

let package = Package(
    name: "BluetoothPrinter",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "BluetoothPrinter",
            targets: ["BluetoothPrinter"]
        )
    ],
    dependencies: [],
    targets:[
        .target(
            name: "BluetoothPrinter",
            exclude:["Info.plist"]
        )
    ]
)
