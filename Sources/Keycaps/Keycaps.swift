import SwiftUI

enum Constants {
    static let aspectRatio = 1.14
    static let animation: Animation = .smooth(duration: 0.1)
    static let bottomOffsetRatio: CGFloat = 8.75
    static let lineWidthRatio: CGFloat = 45
    static let cornerRadiusRatio: CGFloat = 5.8
}

public struct KeycapView<ContentImage: View, ContentText: View>: View {
    public enum Size {
        case small
        case medium
        case large
        case custom(CGFloat)
        
        var height: CGFloat {
            switch self {
            case .small: return 48
            case .medium: return 70
            case .large: return 100
            case .custom(let height): return height
            }
        }
    }
    @ViewBuilder private let image: (() -> ContentImage)
    @ViewBuilder private let text: (() -> ContentText)
    
    private let size: Size
    private let tintColor: Color
    private let shouldSkew: Bool
    
    @Binding private var isPressed: Bool
    
    public init(
        @ViewBuilder image: @escaping () -> ContentImage = { EmptyView() },
        @ViewBuilder text: @escaping () -> ContentText = { EmptyView() },
        isPressed: Binding<Bool>,
        size: Size = .medium,
        tintColor: Color,
        shouldSkew: Bool
    ) {
        self.image = image
        self.text = text
        self._isPressed = isPressed
        self.size = size
        self.tintColor = tintColor
        self.shouldSkew = shouldSkew
    }
    
    public var body: some View {
        ZStack {
            let bottomOffset = size.height / Constants.bottomOffsetRatio
            let lineWidth = size.height / Constants.lineWidthRatio
            let cornerRadius = size.height / Constants.cornerRadiusRatio
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            tintColor.mix(with: .black, by: 0.15),
                            tintColor.mix(with: .white, by: 0.09)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    tintColor.mix(with: .white, by: 0.01),
                                    tintColor.mix(with: .white, by: 0.3)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: lineWidth
                        )
                    
                }
                .offset(y: isPressed ? bottomOffset : 0)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .offset(y: bottomOffset)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        tintColor.mix(with: .black, by: 0.2),
                                        tintColor.mix(with: .white, by: 0.15),
                                        tintColor.mix(with: .black, by: 0.2)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                tintColor.mix(with: .black, by: 0.4),
                                lineWidth: lineWidth
                            )
                            .offset(y: bottomOffset)
                            .clipShape(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .offset(y: bottomOffset)
                            )
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    tintColor.mix(with: .white, by: 0.01),
                                    tintColor.mix(with: .white, by: 0.3)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: lineWidth
                        )
                        .shadow(color: Color.black, radius: 7, x: 0, y: -10)
                        .clipShape(
                            RoundedRectangle(cornerRadius: cornerRadius)
                        )
                        .offset(y: isPressed ? bottomOffset : 0)
                )
                .overlay(
                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .black.opacity(0.4),
                                    .black.opacity(0.05)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: size.height / 2
                            )
                            .blendMode(.overlay)
                        )
                        .padding(.vertical, size.height / 7)
                        .padding(.horizontal, size.height / 14)
                        .offset(y: isPressed ? bottomOffset : 0)
                    
                    
                )
                .frame(width: size.height * Constants.aspectRatio, height: size.height)
                .onTapGesture {
                    isPressed.toggle()
                }
            
            VStack(spacing: size.height / 8) {
                image()
                
                HStack {
                    Spacer()
                    text()
                    Spacer()
                }
            }
            .compositingGroup()
            .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
            .offset(y: isPressed ? bottomOffset : 0)
            .fixedSize()
            .allowsHitTesting(false)
        }
        .if(shouldSkew) {
            $0.rotation3DEffect(
                .degrees(7),
                axis: (x: 1, y: 0, z: 0)
            )
        }
        .animation(Constants.animation, value: isPressed)
        .padding(.horizontal, 5)
        .padding(.top, 5)
        .padding(.bottom, 15)
    }
}

#Preview {
    let skew = false
    VStack {
        HStack {
            Text("Normal buttons")
            Spacer()
        }
        HStack(spacing: 20) {
            KeycapView(
                image: {
                    Image(systemName: "command")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                },
                text: { Text("command") },
                isPressed: .constant(false),
                tintColor: Color(hex: "#496CEC"),
                shouldSkew: skew
            )
            KeycapView(
                image: {
                    Image(systemName: "option")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                },
                text: { Text("option") },
                isPressed: .constant(false),
                tintColor: .green,
                shouldSkew: skew
            )
            KeycapView(
                image: {
                    Image(systemName: "control")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                },
                text: { Text("control") },
                isPressed: .constant(false),
                tintColor: .orange,
                shouldSkew: skew
            )
            KeycapView(
                image: {
                    Image(systemName: "shift")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                },
                text: { Text("shift") },
                isPressed: .constant(false),
                tintColor: Color(.darkGray),
                shouldSkew: skew
            )
        }
        HStack {
            Text("Group perspective")
            Spacer()
        }
        HStack {
            KeycapView(
                text: {
                    Text("H")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                },
                isPressed: .constant(false),
                tintColor: .red,
                shouldSkew: skew
            )
            KeycapView(
                text: {
                    Text("E")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .red,
                shouldSkew: skew
            )
            KeycapView(
                text: {
                    Text("L")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .red,
                shouldSkew: skew
            )
            KeycapView(
                text: {
                    Text("L")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .red,
                shouldSkew: skew
            )
            KeycapView(
                text: {
                    Text("O")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .red,
                shouldSkew: skew
            )
        }
        .rotation3DEffect(
            .degrees(20),
            axis: (x: 1, y: 0, z: 0)
        )
        HStack {
            Text("Individual perspective")
            Spacer()
        }
        HStack {
            KeycapView(
                text: {
                    Text("W")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                },
                isPressed: .constant(false),
                tintColor: .purple,
                shouldSkew: true
            )
            KeycapView(
                text: {
                    Text("O")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .purple,
                shouldSkew: true
            )
            KeycapView(
                text: {
                    Text("R")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .purple,
                shouldSkew: true
            )
            KeycapView(
                text: {
                    Text("L")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .purple,
                shouldSkew: true
            )
            KeycapView(
                text: {
                    Text("D")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                },
                isPressed: .constant(false),
                tintColor: .purple,
                shouldSkew: true
            )
        }
    }
    .padding(50)
}
