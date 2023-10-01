import ComposableArchitecture
import SwiftUI
import DesignSystem

struct MainPage {
  
  let store: StoreOf<MainStore>
  @ObservedObject private var viewStore: ViewStoreOf<MainStore>
  
  init(store: StoreOf<MainStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
}

extension MainPage: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Main Page")
      Spacer()
    }
  }
}
