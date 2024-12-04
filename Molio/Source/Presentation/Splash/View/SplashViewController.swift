import Combine
import UIKit

final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    private var input: SplashViewModel.Input
    private var output: SplashViewModel.Output
    
    private let viewDidLoadPublisher = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
        label.font = UIFont(name: "GmarketSansTTFBold", size: 54)
        label.text = StringLiterals.title
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
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        self.input = SplashViewModel.Input(viewDidLoad: viewDidLoadPublisher.eraseToAnyPublisher())
        self.output = viewModel.transform(from: input)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        viewDidLoadPublisher.send()
        setupHierarchy()
        setupConstraint()
        setupBindings()
    }
    
    private func setupBindings() {
        output.navigateToNextScreen
            .receive(on: RunLoop.main)
            .sink { [weak self] nextScreenType in
                guard let self else { return }
                self.switchNextViewController(nextScreenType)
            }
            .store(in: &cancellables)
    }
    
    private func switchNextViewController(_ nextScreenType: SplashViewModel.NextScreenType) {
        let nextViewController: UIViewController
        // 온보딩 체크
        let isOnboarded = UserDefaults.standard.bool(forKey: UserDefaultKey.isOnboarded.rawValue)
        if isOnboarded {
            switch nextScreenType {
            case .login:
                nextViewController = LoginViewController(viewModel: LoginViewModel())
            case .main:
                nextViewController = MolioTabBarController()
            }
        } else {
            let onboardingVC = OnBoardingPlaylistViewController()
            nextViewController = UINavigationController(rootViewController: onboardingVC)
        }
        
        guard let window = self.view.window else { return }
        
        UIView.transition(with: window, duration: 0.5) {
            nextViewController.view.alpha = 0.0
            window.rootViewController = nextViewController
            nextViewController.view.alpha = 1.0
        }
        
        window.makeKeyAndVisible()
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
