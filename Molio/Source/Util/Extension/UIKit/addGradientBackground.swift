import UIKit

extension UIView {
    func addGradientBackground(
        gradientColors: [UIColor] = [
            UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.23),
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.30),
            UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.25)
        ],
        gradientStartPoint: CGPoint = CGPoint(x: 0, y: 0),
        gradientEndPoint: CGPoint = CGPoint(x: 1, y: 0),
        blurStyle: UIBlurEffect.Style = .regular
    ) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = gradientStartPoint
        gradientLayer.endPoint = gradientEndPoint
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)

        // 블러 효과 추가
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
}
