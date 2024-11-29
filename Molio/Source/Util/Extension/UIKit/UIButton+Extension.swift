import UIKit

extension UIButton {
    /// UIButton에 폰트를 적용
    /// - `UIButton(type: .system)`의 경우에만 적용
    private func applyFont(
        _ label: String,
        font: String,
        foregroundColor: UIColor? = nil,
        size: CGFloat = 17
    ) {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)
        ]
        if let foregroundColor = foregroundColor {
            attributes[.foregroundColor] = foregroundColor
        }
        
        let attributedTitle = NSAttributedString(string: label, attributes: attributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    static func molioBlack(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Black, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioBold(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Bold, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioExtraBold(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.ExtraBold, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioSemiBold(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.SemiBold, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioMedium(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Medium, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioRegular(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Regular, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioThin(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Thin, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioLight(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.Light, foregroundColor: foregroundColor, size: size)
        return button
    }
    
    static func molioExtraLight(text: String, size: CGFloat, foregroundColor: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.applyFont(text, font: PretendardFontName.ExtraLight, foregroundColor: foregroundColor, size: size)
        return button
    }
}

// 사용 예시
// let button = UIButton.molioBold(text: "버튼", size: 17, foregroundColor: .main)
