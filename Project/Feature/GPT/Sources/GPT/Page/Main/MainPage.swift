import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - MainPage

struct MainPage {
  
  init(store: StoreOf<MainStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
  
  let store: StoreOf<MainStore>
  @ObservedObject private var viewStore: ViewStoreOf<MainStore>
  @Namespace private var lastMessage
}

extension MainPage {
  private var isLoading: Bool {
    viewStore.fetchMessage.isLoading
  }
  
  private var message: String {
    viewStore.fetchMessage.value.content
  }
}

// MARK: View

extension MainPage: View {
  var body: some View {
    VStack {
      Spacer()
      
      Text("GPT에게 말해봐요")
      
      ScrollViewReader { proxy in
        ScrollView {
          Text(message)
          
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .opacity(isLoading ? 1 : .zero)
            .id(lastMessage)
        }
        .onChange(of: message) { _, _ in
          proxy.scrollTo(lastMessage, anchor: .bottom)
        }
      }
      
      Spacer()
      switch isLoading {
      case true:
        HStack {
          Text("출력중.....")
          Button(action: { viewStore.send(.onTapCancel)}) {
            Text("중단")
          }
        }
        
      case false:
        HStack(alignment: .bottom) {
          TextField("", text: viewStore.$message, prompt: Text("여기에 입력하세요"), axis: .vertical)
            .frame(minHeight: 50)
            .onSubmit {
              viewStore.send(.onTapSendMessage)
            }
          
          Button(action: { viewStore.send(.onTapSendMessage) }) {
            Text("전송")
              .frame(minHeight: 50)
          }
        }
        .disabled(isLoading)
        .padding(.horizontal, 16)
        .border(Color.blue)
        .frame(maxHeight: 120)
        
      }
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}
