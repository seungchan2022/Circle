import LinkNavigator

public struct GPTRouteBuilderGroup<RootNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable> {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      MainRouteBuilder.generate(),
      Chapter1RouteBuilder.generate(),
    ]
  }
}
