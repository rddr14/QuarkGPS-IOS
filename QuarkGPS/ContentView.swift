import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WebViewViewModel()

    var body: some View {
        WebViewContainer(
            url: URL(string: "https://rastrear.quarkgps.com")!,
            allowedHost: "rastrear.quarkgps.com",
            viewModel: viewModel
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
