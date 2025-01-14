import SwiftUI

struct ShakeEffect: ViewModifier {
  let shake: Bool
    
  func body(content: Content) -> some View {
    content
      .offset(x: shake ? Constants.Animation.shakeIntensity : 0)
      .animation(
        .linear(duration: Constants.Animation.shakeRepeatDuration)
        .repeatCount(Constants.Animation.shakeRepeatCount, autoreverses: true),
        value: shake
      )
  }
}
