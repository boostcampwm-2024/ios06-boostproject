import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @ObservedObject var viewModel: CreatePlaylistViewModel

    var placeholder: String = "플레이리스트 이름을 입력해주세요"

    var body: some View {
        ZStack {
            Color(.clear)
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 40)
                
                Text("플레이리스트 만들기")
                    .font(.custom(PretendardFontName.Bold, size: 28))
                    .foregroundStyle(Color.white)
                            
                VStack {
                    ZStack(alignment: .center) {
                        if text.isEmpty && !isFocused {
                            Text(placeholder)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                        
                        TextField("", text: $text)
                            .padding(.bottom, 5)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .font(.custom(PretendardFontName.Medium, size: 20))
                            .frame(height: 40)
                            .multilineTextAlignment(.center)
                            .focused($isFocused)
                    }
                    .frame(height: 40)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 40)
                
                HStack {
                    BasicButton(type: .cancel) {
                        dismiss()
                    }
                    BasicButton(type: .confirm, isEnabled: !text.isEmpty) {
                        Task {
                            await viewModel.createPlaylist(named: text)
                            viewModel.changeCurrentPlaylist()
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 22)
                
                Spacer()
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    CreatePlaylistView(viewModel: CreatePlaylistViewModel())
        .background(Color.background)
}
