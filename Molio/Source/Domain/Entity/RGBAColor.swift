import Foundation

/// 음악 정보의 색상을 표현하는 Entity입니다.
struct RGBAColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    static let background = RGBAColor(
        red: 50/255,
        green: 50/255,
        blue: 50/255,
        alpha: 1.0
    )
}
