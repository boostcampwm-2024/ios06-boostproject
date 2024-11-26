import Combine
import Foundation

final class SplahViewModel: InputOutputViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let navigateToNextScreen: AnyPublisher<NextScreenType, Never>
    }
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    private let navigateToNextScreenPublisher = PassthroughSubject<NextScreenType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .delay(for: .seconds(1.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let nextScreen = manageAuthenticationUseCase.isAuthModeSelected() 
                ? NextScreenType.main
                : NextScreenType.login
                navigateToNextScreenPublisher.send(nextScreen)
            }
            .store(in: &cancellables)
        
        return Output(navigateToNextScreen: navigateToNextScreenPublisher.eraseToAnyPublisher())
    }
    
    enum NextScreenType {
        case login
        case main
    }
}
