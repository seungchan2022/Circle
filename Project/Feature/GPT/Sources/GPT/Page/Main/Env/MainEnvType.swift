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
          .map { res -> MainStore.MessageScope in
            guard let pick = res.choiceList.first else { return .init() }

            return .init(
              content: pick.delta.content ?? "" ,
              isFinish: (pick.finishReason ?? "").lowercased() == "stop")
          }
          .mapToResult()
          .receive(on: mainQueue)
          .map { .fetchMessage($0) }
      }
    }
  }
}
