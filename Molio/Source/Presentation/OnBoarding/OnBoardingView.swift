import SwiftUI

struct OnBoardingView: View {
    private let page: OnBoardingPage
    var didButtonTapped: (() -> Void)?
    
    @State var isAppleMusicPermissonAllowed: Bool = false
    @State var shoudModifyInSettingsApp: Bool = false
    private let musicKitService: MusicKitService
    
    init(
        page: OnBoardingPage,
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.page = page
        self.musicKitService = musicKitService
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text.molioBold(page.title, size: 24)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subTitle = page.subTitle {
                        Text.molioMedium(subTitle, size: 16)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                if let image = page.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    appleMusicPermisonRequestView()
                    if shoudModifyInSettingsApp {
                        Button {
                            openSettingsApp()
                        } label: {
                            Text.molioRegular("⚙️ 설정 앱에서 Apple Music 권한을 허용해주세요", size: 17)
                                .foregroundStyle(.mainLighter)
                        }

                    }
                }
                
                Spacer()
                
                switch page {
                case .seven:
                    BasicButton(type: .startMolio, isEnabled: isAppleMusicPermissonAllowed) {
                        didButtonTapped?()
                    }
                default:
                    BasicButton(type: .onBoarding) {
                        didButtonTapped?()
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
            .onAppear {
                if page == .seven {
                    requestAppleMusicPermission()
                }
            }
        }
    }
    
    private func appleMusicPermisonRequestView() -> some View {
        VStack(alignment: .leading) {
            Text.molioMedium("필수 권한", size: 16)
                .foregroundStyle(.gray)
            HStack(alignment: .center) {
                Image("appleMusicLogo")
                    .resizable()
                    .frame(width: 49, height: 49)
                Text.molioSemiBold("미디어 및 Apple Music", size: 18)
                    .fixedSize(horizontal: true, vertical: false)
                Toggle(isOn: Binding(
                    get: { isAppleMusicPermissonAllowed },
                    set: { _ in requestAppleMusicPermission() }
                )) {
                    Text("Request Apple Music Permission")
                }
                .labelsHidden()
            }
            .padding(.vertical, 45)
            .padding(.horizontal, 27)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.white)
            }
        }
    }
    
    private func requestAppleMusicPermission() {
        Task {
            do {
                try await musicKitService.checkAuthorizationStatus()
                isAppleMusicPermissonAllowed = true
            } catch {
                isAppleMusicPermissonAllowed = false
                shoudModifyInSettingsApp = true
            }
        }
    }
    
    private func openSettingsApp() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
}

#Preview {
    OnBoardingView(page: .seven)
}
