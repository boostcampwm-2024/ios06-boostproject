import UIKit

final class CircleMenuButton: UIButton {
    private let defaultBackgroundColor: UIColor
    private let highlightBackgroundColor: UIColor
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.clipsToBounds = true
        effectView.isUserInteractionEnabled = false
        effectView.alpha = 0.5
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.blurEffectView.backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
        }
    }
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(
        backgroundColor: UIColor,
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
        setupView(
            backgroundColor: backgroundColor,
            buttonSize: buttonSize,
            tintColor: tintColor,
            buttonImage: buttonImage
        )
        setupHierarchy()
        setupConstraint(
            buttonSize: buttonSize,
            buttonImageSize: buttonImageSize
        )
    }
    
    required init?(coder: NSCoder) {
        self.defaultBackgroundColor = .black.withAlphaComponent(0.51)
        self.highlightBackgroundColor = defaultBackgroundColor.withAlphaComponent(0.8)
        super.init(coder: coder)
    }
    
    private func setupView(
        backgroundColor: UIColor,
        buttonSize: CGFloat,
        tintColor: UIColor?,
        buttonImage: UIImage?
    ) {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.cornerRadius = buttonSize / 2
        
        blurEffectView.layer.cornerRadius = buttonSize / 2
        blurEffectView.backgroundColor = backgroundColor
        
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
