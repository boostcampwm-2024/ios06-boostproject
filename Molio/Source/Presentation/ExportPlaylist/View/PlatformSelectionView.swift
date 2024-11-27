import SwiftUI

struct PlatformSelectionView: View {
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
            
            BasicButton(type: .next) {
                print("다음 버튼 누름")
            }
        }
        .padding(.vertical, 35)
        .padding(.horizontal, 22)
    }
}

#Preview {
    ZStack {
        Color.background
        PlatformSelectionView()
    }
}
