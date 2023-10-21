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
  @State private var selectedModel = 0
}

extension MainPage {
  private var isLoading: Bool {
    viewStore.fetchMessage.isLoading
  }
  
  private var chatList: [MainStore.MessageScope] {
    viewStore.chatList
  }
  
  private func showNewChat() {
  }
  
  private func showHistory() {
  }
  
  private func showSetting() {
  }
}

// MARK: View

extension MainPage: View {
  var body: some View {
    VStack {
      HStack {
        
        Picker("GPT Model", selection: $selectedModel) {
          Text("GPT-3.5")
            .tag(0)
          Text("GPT-4")
            .tag(1)
        }
        
        .frame(height: 60)
        .pickerStyle(SegmentedPickerStyle())
        
        Menu {
          ControlGroup {
            Button(action: { showNewChat() }) {
              VStack {
                Image(systemName: "plus")
                Text("New Chat")
              }
            }
            
            Button(action: { showHistory() }) {
              VStack {
                Image(systemName: "clock")
                Text("History")
              }
            }
            
            Button(action: { showSetting() }) {
              VStack {
                Image(systemName: "gearshape.fill")
                Text("Settings")
              }
            }
          }
          
        } label: {
          Button(action: { }) {
            Image(systemName: "ellipsis")
              .renderingMode(.template)
              .foregroundColor(.gray)
          }
          .frame(width: 50, height: 50)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.gray.opacity(0.5)))
        }
        
      }
      
      
      //      ScrollViewReader { proxy in
      if selectedModel == 0 {
        
        ScrollView {
          LazyVStack {
            ForEach(chatList, id: \.id) { item in
              ChatItemComponent(viewState: .init(item: item))
            }
          }
          //        }
          //        .onChange(of: chatList) { _, _ in
          //          proxy.scrollTo(lastMessage, anchor: .bottom)
          //        }
        }
      }
      
      Spacer()
      
      HStack(spacing: 8) {
        Group {
          TextField(
            "",
            text: viewStore.$message,
            prompt: Text("Message").foregroundColor(.gray.opacity(0.3)),
            axis: .vertical)
          .lineLimit(1...3)
          .onSubmit {
            viewStore.send(.onTapSendMessage)
          }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.gray, lineWidth: 1)
        )
        
        
        Button(action: { viewStore.send(.onTapSendMessage) }) {
          Image(systemName: "arrow.up.circle.fill")
            .renderingMode(.template)
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(!viewStore.message.isEmpty ? Color.purple : Color.purple.opacity(0.3))
        }
        .disabled(viewStore.message.isEmpty)
      }
      .padding(.vertical, 8)
      .disabled(isLoading)
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}

// MARK: MainPage.ChatItemComponent

extension MainPage {
  struct ChatItemComponent {
    var viewState: ViewState
  }
}

// MARK: - MainPage.ChatItemComponent + View

extension MainPage.ChatItemComponent: View {
  var body: some View {
    VStack {
      switch viewState.item.role {
      case .user:
        HStack(alignment: .top) {
          Spacer()
          Text(viewState.item.content)
          
            .foregroundColor(.black)
            .padding()
            .background(
              UnevenRoundedRectangle(
                cornerRadii: .init(
                  topLeading: 20.0,
                  bottomLeading: 20.0,
                  bottomTrailing: 20.0,
                  topTrailing: .zero),
                style: .continuous)
            )
          
          Image(systemName: "person.crop.circle.badge.questionmark.fill")
            .renderingMode(.template)
            .resizable()
            .frame(width: 30, height: 30)
          
        }
        .foregroundStyle(viewState.item.isFinish ? Color.yellow.opacity(0.3) : Color.gray)
        
        
      case .ai:
        HStack(alignment: .top) {
          Image(systemName: "headphones.circle.fill")
            .renderingMode(.template)
            .resizable()
            .frame(width: 30, height: 30)
          
          Text(viewState.item.content)
            .foregroundColor(.black)
            .padding()
            .background(
              UnevenRoundedRectangle(
                cornerRadii: .init(
                  topLeading: 20.0,
                  bottomLeading: 20.0,
                  bottomTrailing: 20.0,
                  topTrailing: .zero),
                style: .continuous)
            )
          
          Spacer()
        }
        .foregroundStyle(viewState.item.isFinish ? Color.green.opacity(0.3) : Color.gray)
        
        
        if !viewState.item.isFinish {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .tint(.blue)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - MainPage.ChatItemComponent.ViewState

extension MainPage.ChatItemComponent {
  struct ViewState: Equatable {
    let item: MainStore.MessageScope
  }
}
