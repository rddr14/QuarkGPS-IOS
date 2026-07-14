import Foundation

struct WhiteLabelConfig {
    let key: String
    let appName: String
    let siteURL: URL
    let allowedHost: String
}

enum WhiteLabelResolver {
    private static let fallbackKey = "quarkgps"

    private static let configs: [String: WhiteLabelConfig] = [
        "quarkgps": WhiteLabelConfig(
            key: "quarkgps",
            appName: "QuarkGPS",
            siteURL: URL(string: "https://rastrear.quarkgps.com")!,
            allowedHost: "rastrear.quarkgps.com"
        ),
        "auramonitoramento": WhiteLabelConfig(
            key: "auramonitoramento",
            appName: "Aura Monitoramento",
            siteURL: URL(string: "https://auramonitoramento.com.br")!,
            allowedHost: "auramonitoramento.com.br"
        )
    ]

    static func current(bundle: Bundle = .main) -> WhiteLabelConfig {
        let configuredKey = (bundle.object(forInfoDictionaryKey: "WhiteLabelKey") as? String)?.lowercased()
        let selectedKey = configuredKey ?? fallbackKey
        return configs[selectedKey] ?? configs[fallbackKey]!
    }
}
