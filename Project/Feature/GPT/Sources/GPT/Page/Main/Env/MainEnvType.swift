import ComposableArchitecture
import Domain
import Foundation

// MARK: - MainEnvType

protocol MainEnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var sendMessage: (String) -> Effect<MainStore.Action> { get }
}

extension MainEnvType {
  public var sendMessage: (String) -> Effect<MainStore.Action> {
    { message in
      .publisher {
        useCaseGroup.streamUseCase
          .sendMessage(message)
          .map { res -> String in
            print(res)
            return res.choiceList.first?.message.content ?? ""
          }
          .mapToResult()
          .receive(on: mainQueue)
          .map { .fetchMessage($0) }
      }
    }
  }
}
