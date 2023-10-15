import Architecture
import LinkNavigator
import Platform
import SwiftUI

@main
struct AppMain: App {

  @StateObject var viewModel = AppMainViewModel()

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: viewModel.linkNavigator,
        item: .init(path: Link.GPT.Path.chapter1.rawValue, items: ""))
        .ignoresSafeArea()
    }
  }
}
