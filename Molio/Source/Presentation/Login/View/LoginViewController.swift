import UIKit

final class LoginViewController: UIViewController {
    private let molioTitleLabel: UILabel = {
        let label = UILabel()
        label.molioBold(text: StringLiterals.title, size: 72)
        label.textColor = .main
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let molioSubTitleLabel: UILabel = {
        let label = UILabel()
        label.molioMedium(text: StringLiterals.subTitle, size: 17)
        label.textColor = UIColor(hex: "#8D9F9B")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4E5A58")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.molioRegular(text: StringLiterals.introduction, size: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#8D9F9B")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        let appleLogoImage = UIImage(systemName: "apple.logo", withConfiguration: imageConfig)
        button.setImage(appleLogoImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipLoginButtonLabel: UILabel = {
        let label = UILabel()
        label.molioRegular(text: StringLiterals.skipLogin, size: 14)
        label.textColor = UIColor(hex: "#8E8E93")
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if let attributedText = label.attributedText {
            let mutableAtrributedString = NSMutableAttributedString(attributedString: attributedText)
            mutableAtrributedString.addAttribute(
                .underlineStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: mutableAtrributedString.length)
            )
            label.attributedText = mutableAtrributedString
        }
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupHierarchy()
        setupConstraint()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSkipLoginButtonLabel))
        skipLoginButtonLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapSkipLoginButtonLabel() {
        // TODO: 로그인 없이 시작하는 로직 추가
    }
    
    private func setupHierarchy() {
        view.addSubview(molioTitleLabel)
        view.addSubview(molioSubTitleLabel)
        view.addSubview(verticalLineView)
        view.addSubview(introductionLabel)
        view.addSubview(appleLoginButton)
        view.addSubview(skipLoginButtonLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            molioTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            molioTitleLabel.bottomAnchor.constraint(equalTo: molioSubTitleLabel.topAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            molioSubTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            molioSubTitleLabel.bottomAnchor.constraint(equalTo: verticalLineView.topAnchor, constant: -31)
        ])
        
        NSLayoutConstraint.activate([
            verticalLineView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.47),
            verticalLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 1),
            verticalLineView.heightAnchor.constraint(equalToConstant: 93)
        ])
        
        NSLayoutConstraint.activate([
            introductionLabel.topAnchor.constraint(equalTo: verticalLineView.bottomAnchor, constant: 41),
            introductionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            appleLoginButton.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 41),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 56),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            skipLoginButtonLabel.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 17),
            skipLoginButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension LoginViewController {
    enum StringLiterals {
        static let title: String = "molio"
        static let subTitle: String = "나만의 음악 포트폴리오"
        static let introduction: String = "몰랐던 나의 음악적 취향을 발견할 수 있는\n특별한 여정을 시작해보세요."
        static let skipLogin: String = "로그인 없이 시작할래요"
    }
}
