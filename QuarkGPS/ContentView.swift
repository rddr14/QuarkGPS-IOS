import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WebViewViewModel()
    @Environment(\.scenePhase) private var scenePhase
    private let config = WhiteLabelResolver.current()

    var body: some View {
        WebViewContainer(
            url: config.siteURL,
            allowedHost: config.allowedHost,
            viewModel: viewModel
        )
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                viewModel.markDidEnterBackground()
            case .active:
                viewModel.reloadIfAppWasBackgroundedForLongTime()
            default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
