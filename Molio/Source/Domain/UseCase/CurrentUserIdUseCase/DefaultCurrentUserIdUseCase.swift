struct DefaultCurrentUserIdUseCase: CurrentUserIdUseCase {
    private let authService: AuthService
    private let usecase: ManageAuthenticationUseCase
    
    init(
        authService: AuthService = DIContainer.shared.resolve(),
        usecase: ManageAuthenticationUseCase = DIContainer.shared.resolve()
    ) {
        self.authService = authService
        self.usecase = usecase
    }
    // TODO: 로그인 재인증 로직 (로그인 화면으로 이동, 재인증 후 다시 불러오기 등) 처리
    func execute() throws -> String? {
        if usecase.isLogin() {
            do {
                return try authService.getCurrentID()
            } catch  {
                print("error.localizedDescription")
            }
        }
        return nil
    }
}
