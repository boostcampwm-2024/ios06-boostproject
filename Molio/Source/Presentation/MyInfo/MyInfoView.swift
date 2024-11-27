import SwiftUI

struct MyInfoView: View {
    @ObservedObject private var viewModel: MyInfoViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @Namespace private var topID
    @Namespace private var descriptionID
    
    enum Field: Hashable {
        case nickname
        case description
    }
    
    init(viewModel: MyInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: viewModel.userImageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else {
                                    Image(uiImage: UIImage(resource: .personCircle))
                                        .resizable()
                                }
                            }
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            Button(action: {
                                // TODO: 이미지 선택 액션
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 22, height: 22)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(.black)
                                }
                            }
                            .offset(x: -4, y: -4)
                        }
                        .padding(.top, 22)
                        .id(topID)
                        
                        Spacer()
                            .frame(height: 15)
                        
                        NickNameTextFieldView(
                            characterLimit: viewModel.nickNameCharacterLimit,
                            isPossibleInput: viewModel.isPossibleNickName,
                            text: $viewModel.userNickName
                        )
                        .focused($focusedField, equals: .nickname)
                        
                        Spacer()
                            .frame(height: 22)
                        
                        DescriptionTextFieldView(
                            characterLimit: viewModel.descriptionCharacterLimit,
                            isPossibleInput: viewModel.isPossibleDescription,
                            text: $viewModel.userDescription
                        )
                        .frame(maxHeight: 105)
                        .focused($focusedField, equals: .description)
                        .id(descriptionID)
                        
                        Spacer(minLength: 115)
                    }
                }
                .scrollDisabled(true)
                .onChange(of: focusedField) { field in
                    switch field {
                    case .description:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                            withAnimation {
                                proxy.scrollTo(descriptionID, anchor: .top)
                            }
                        }
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                            withAnimation {
                                proxy.scrollTo(topID, anchor: .top)
                            }
                        }
                    }
                }
            }
            .background(Color.background)
            .navigationTitle("내 정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("설정")
                        }
                        .foregroundStyle(.main)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                BasicButton(
                    type: .confirm,
                    isEnabled: viewModel.isPossibleConfirmButton
                ) {
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 66)
                .padding(.horizontal, 22)
                .padding(.bottom, 34)
            }
            .onTapGesture {
                focusedField = .none
            }
        }
    }
}

#Preview {
    MyInfoView(viewModel: MyInfoViewModel(
        userNickName: "몰리오 올리오",
        userDescription: "안녕하세요 오늘은 어떤 음악을 들어볼까요?")
    )
}
