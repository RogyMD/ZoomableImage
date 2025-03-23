import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct ZoomableImage: View {
  private let image: Image
  private let contentMode: ContentMode
  @Binding private var magnification: CGFloat?
  
  @GestureState private var magnifyValue: MagnifyGesture.Value?
  private var scale: CGFloat {
    magnification ?? 1
  }
  private var anchor: UnitPoint {
    magnifyValue?.startAnchor ?? .center
  }
  
  public init(
    image: Image,
    contentMode: ContentMode = .fit,
    magnification: Binding<CGFloat?> = .constant(nil)
  ) {
    self.image = image
    self.contentMode = contentMode
    _magnification = magnification
  }
  
  public var body: some View {
    GeometryReader { proxy in
      ZStack {
        image
          .resizable()
          .aspectRatio(contentMode: contentMode)
          .scaleEffect(scale, anchor: anchor)
          .gesture(
            MagnifyGesture()
            .updating($magnifyValue) { value, state, _ in
              state = value
            }
          )
          .animation(Self.zoomAnimation, value: scale)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
    }
    .onChange(of: magnifyValue) { _, newValue in
      magnification = newValue?.magnification
    }
  }
  
  private static let zoomAnimation = Animation.bouncy(duration: 0.4, extraBounce: 0.1)
}
