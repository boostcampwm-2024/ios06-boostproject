import UIKit

final class SplashViewController: UIViewController {
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupHierarchy()
        setupConstraint()
    }
    
    private func setupHierarchy() {
        view.addSubview(titleStackView)
        titleStackView.addArrangedSubview(molioTitleLabel)
        titleStackView.addArrangedSubview(molioSubTitleLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController {
    enum StringLiterals {
        static let title: String = "molio"
        static let subTitle: String = "음악 취향을 모르겠다면, 몰리오!"
    }
}
