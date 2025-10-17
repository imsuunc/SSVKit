// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSVKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "SSFoundation",
            targets: [
                "SSFoundation"
            ]),
        .library(
            name: "SSConstraint",
            targets: [
                "SSConstraint"
            ]),
        .library(
            name: "SSRouting",
            targets: [
                "SSRouting"
            ]),
        .library(
            name: "SSView",
            targets: [
                "SSView"
            ]),
        .library(
            name: "SSVKit",
            targets: [
                "SSVKit"
            ])
        
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "SSVKit",
                dependencies: [
                    "SSConstraint",
                    "SSFoundation",
                    "SSRouting",
                    "SSView"
                ]),
        .target(name: "SSView",
                dependencies: [
                    "SSConstraint",
                    "SSFoundation"
                ]),
        .target(name: "SSRouting",
                dependencies: [
                    "SSView"
                ]),
        .target(name: "SSFoundation",
                dependencies: [
                ]),
        .target(name: "SSConstraint",
                dependencies: [
                ])
    ]
)
