import UIKit

final class CircleMenuButton: UIButton {
    
    private var defaultBackgroundColor: UIColor
    private var highlightBackgroundColor: UIColor
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.layer.cornerRadius = 0 // 초기값, 버튼 크기에 따라 조정
        effectView.clipsToBounds = true
        effectView.isUserInteractionEnabled = false // 터치 이벤트를 블러 뷰가 소모하지 않도록 설정
        effectView.alpha = 0.5

        return effectView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
        }
    }
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(backgroundColor: UIColor,
         highlightColor: UIColor? = nil,
         buttonSize: CGFloat,
         tintColor: UIColor?,
         buttonImage: UIImage?,
         buttonImageSize: CGSize
    ) {
        self.defaultBackgroundColor = backgroundColor
        self.highlightBackgroundColor = highlightColor ?? backgroundColor.withAlphaComponent(0.8)
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView(backgroundColor: backgroundColor,
                  buttonSize: buttonSize,
                  tintColor: tintColor,
                  buttonImage: buttonImage)
        setupHierarchy()
        setupConstraint(buttonSize: buttonSize, buttonImageSize: buttonImageSize)
    }
    
    required init?(coder: NSCoder) {
        self.defaultBackgroundColor = .black.withAlphaComponent(0.51)
        self.highlightBackgroundColor = defaultBackgroundColor.withAlphaComponent(0.8)
        super.init(coder: coder)
    }
    
    private func setupView(backgroundColor: UIColor,
                           buttonSize: CGFloat,
                           tintColor: UIColor?,
                           buttonImage: UIImage?
    ) {
        // Apply blur effect for glassmorphism
        blurEffectView.layer.cornerRadius = buttonSize / 2
        self.insertSubview(blurEffectView, at: 0)
        
        self.backgroundColor = .clear // Transparent to show blur effect
        layer.cornerRadius = buttonSize / 2
        clipsToBounds = true
        buttonImageView.tintColor = tintColor
        buttonImageView.image = buttonImage
    }
    
    private func setupHierarchy() {
        addSubview(blurEffectView)
        addSubview(buttonImageView)
    }
    
    private func setupConstraint(buttonSize: CGFloat, buttonImageSize: CGSize) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: buttonSize),
            self.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonImageView.widthAnchor.constraint(equalToConstant: buttonImageSize.width),
            buttonImageView.heightAnchor.constraint(equalToConstant: buttonImageSize.height),
            buttonImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
