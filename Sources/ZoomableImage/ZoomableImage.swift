import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct ZoomableImage: View {
  private let image: Image
  private let contentMode: ContentMode
  @Binding private var isZooming: Bool
  
  @GestureState private var magnifyValue: MagnifyGesture.Value?
  private var scale: CGFloat {
    magnifyValue?.magnification ?? 1
  }
  private var anchor: UnitPoint {
    magnifyValue?.startAnchor ?? .center
  }
  
  public init(
    image: Image,
    contentMode: ContentMode = .fit,
    isZooming: Binding<Bool> = .constant(false)
  ) {
    self.image = image
    self.contentMode = contentMode
    _isZooming = isZooming
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
    .onChange(of: scale) { oldValue, newValue in
      isZooming = scale != 1
    }
  }
  
  private static let zoomAnimation = Animation.bouncy(duration: 0.4, extraBounce: 0.1)
}
