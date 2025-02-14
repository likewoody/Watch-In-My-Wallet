import ProjectDescription

let appName: String = "WatchInMyWallet"
let bundleId: String = "com.peppo.watchInMyWallet"
let infoPlist: [String: Plist.Value] = [
    "UILaunchScreen": [
        "UIColorName": "",
        "UIImageName": "",
    ],
]
let project = Project(
    name: "WatchInMyWallet",
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["WatchInMyWallet/Sources/**"],
            resources: ["WatchInMyWallet/Resources/**"],
            dependencies: [
                // 추후 라이브러리 아래와 같이 추가 (Package.swift 에도 수정필요)
    //                .external(name: "Alamofire")
            ]
        ),
        .target(
            name: "WatchInMyWalletTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.WatchInMyWalletTests",
            infoPlist: .default,
            sources: ["WatchInMyWallet/Tests/**"],
            resources: [],
            dependencies: [.target(name: "WatchInMyWallet")]
        ),
    ]
)
