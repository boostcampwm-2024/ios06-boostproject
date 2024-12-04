import SwiftUI

struct ProfileItemView: View {
    @Binding var molioUser: MolioUser?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                
                ProfileImageView(imageURL: molioUser?.profileImageURL, size: 52)
                .padding(.leading, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
                
                VStack(alignment: .leading) {
                    Text(molioUser?.name ?? "")
                        .font(.pretendardRegular(size: 16))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)

                    Text(molioUser?.description ?? "")
                        .font(.pretendardRegular(size: 15))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
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
