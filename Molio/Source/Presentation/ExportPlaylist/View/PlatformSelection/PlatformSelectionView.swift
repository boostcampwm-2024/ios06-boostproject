import SwiftUI

struct PlatformSelectionView: View {
    @ObservedObject var viewModel: PlaylistDetailViewModel
    @State private var selectedPlatform: ExportPlatform?
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text.molioBold("플랫폼 선택", size: 32) // TODO: - 네이밍 수정 (ex - 내보내기 방식 선택)
                .foregroundStyle(Color.white)
            
            HStack(alignment: .center, spacing: 10) {
                ForEach(ExportPlatform.allCases) { platform in
                    HStack {
                        Spacer()
                        platform.image
                            .resizable()
                            .frame(width: 20, height: 20)
                        Spacer()
                    }
                    .padding(.vertical, 9)
                    .foregroundStyle(Color.white)
                    .background {
                        Capsule()
                            .fill(selectedPlatform == platform ? Color.main : .clear)
                    }
                    .overlay {
                        Capsule()
                            .stroke(selectedPlatform == platform ? .clear : .white, lineWidth: 2)
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        selectedPlatform = platform
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            nextButton()
        }
        .padding(.vertical, 35)
        .padding(.horizontal, 22)
        .onAppear {
            viewModel.checkAppleMusicSubscription()
        }
    }
    
    private func nextButton() -> some View {
        guard let selectedPlatform = selectedPlatform else {
            return BasicButton(type: .didNotSelectPlatform, isEnabled: false)
        }
        if selectedPlatform == .appleMusic {
            if viewModel.isAppleMusicSubscriber {
                return BasicButton(type: .exportToAppleMusic) {
                    // TODO: - 애플 뮤직 내보내기
                }
            } else {
                return BasicButton(type: .needAppleMusicSubcription, isEnabled: false)
            }
        } else {
            return BasicButton(type: .exportToImage) {
                // TODO: - 이미지로 내보내기
            }
        }
    }
}

#Preview {
    ZStack {
        Color.background
        PlatformSelectionView(viewModel: PlaylistDetailViewModel())
    }
}
