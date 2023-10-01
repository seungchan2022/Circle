import Foundation
import ComposableArchitecture

struct MainStore {
  
  let env: MainEnvType
  private let pageeID = UUID().uuidString
}


extension MainStore: Reducer {
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .teardown:
        return .none
      }
    }
  }
}

extension MainStore {
  struct State: Equatable {
  }
}

extension MainStore {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)
  }
}

extension MainStore {
  enum CancelID: Equatable, CaseIterable {
    
  }
}
