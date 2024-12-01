import SwiftUI

struct ProfileImageView: View {
    let imageURL: URL?
    let placeholderIconName: String
    let size: CGFloat

    init(imageURL: URL?, placeholderIconName: String = "person.fill", size: CGFloat = 50) {
        self.imageURL = imageURL
        self.placeholderIconName = placeholderIconName
        self.size = size
    }

    var body: some View {
        if let imageURL = imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 로딩 중
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                case .failure(_):
                    placeholderView
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: placeholderIconName)
                    .foregroundColor(.white)
            )
    }
}
