import SwiftUI

struct NotificationView: View {
    @ObservedObject private var viewModel: NotificationViewModel
    
    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.pendingFollowRequests.isEmpty {
                Text("알림이 없습니다.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    
                    ForEach(viewModel.pendingFollowRequests) { user in
                        HStack(spacing: 0) {
                            ProfileImageView(imageURL: user.profileImageURL, size: 42)
                            Spacer()
                                .frame(width: 12)
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(user.name)
                                            .font(.pretendardRegular(size: 17))
                                            .foregroundStyle(.white)
                                        Text(user.description ?? "")
                                            .font(.pretendardRegular(size: 14))
                                            .foregroundStyle(.gray)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Text("거절")
                                            .font(.pretendardRegular(size: 15))
                                            .foregroundStyle(.white)
                                            .frame(width: 70, height: 32)
                                            .background(.white.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    
                                    Spacer()
                                        .frame(width: 7)
                                    Button {
                                        
                                    } label: {
                                        Text("수락")
                                            .font(.pretendardRegular(size: 15))
                                            .foregroundStyle(.black)
                                            .frame(width: 70, height: 32)
                                            .background(.mainLighter)
                                            .cornerRadius(10)
                                    }
                                }
                                Divider()
                                    .background(Color(UIColor.darkGray))
                            }
                        }
                        .frame(height: 56)
                        .padding(EdgeInsets(
                            top: 6,
                            leading: 16,
                            bottom: 6,
                            trailing: 13
                        ))
                    }
                }
            }
        } 
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}
 
