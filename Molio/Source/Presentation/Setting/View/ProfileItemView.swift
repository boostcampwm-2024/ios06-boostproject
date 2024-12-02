import SwiftUI

struct ProfileItemView: View {
    @Binding var molioUser: MolioUser?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AsyncImage(url: molioUser?.profileImageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 52, height: 52)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: UIImage(resource: .personCircle))
                            .resizable()
                            .frame(width: 52, height: 52)
                            .clipShape(Circle())
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
                
                VStack(alignment: .leading) {
                    Text(molioUser?.name ?? "")
                        .font(.pretendardRegular(size: 16))
                        .foregroundStyle(.white)
                    Text(molioUser?.description ?? "")
                        .font(.pretendardRegular(size: 15))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .padding(.trailing, 16)
            }
        }
        .background(Color(uiColor: UIColor(resource: .background)))
    }
}
