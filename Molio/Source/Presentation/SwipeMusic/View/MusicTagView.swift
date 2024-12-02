import UIKit

final class MusicTagView: UIView {
    
    private let tagTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let blurEffectView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.23).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor,
            UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.25).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = containerView.bounds
        gradientLayer.cornerRadius = 10
        containerView.layer.insertSublayer(gradientLayer, at: 0)

        // 블러 효과 추가
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(blurEffectView)

        return containerView
    }()
    
    init(tagTitle: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayer()
        setupHierarchy()
        setupConstraint()
        tagTitleLabel.molioMedium(text: tagTitle, size: 14)
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
        setupHierarchy()
        setupConstraint()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupHierarchy() {
        addSubview(blurEffectView)
        addSubview(tagTitleLabel)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            tagTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            tagTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            tagTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            tagTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18)
        ])
    }
}
