import SwiftUI

struct CommunityPagePlaylistCellView: View {
    var playlist: MolioPlaylist
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Spacer()
                
                Text(playlist.name)

                Spacer()

                HStack {
                    // TODO: - 필터가 많은 경우 처리
                    
                    ForEach(playlist.filters.prefix(5), id: \.self) { filter in
                        Text(filter)
                            .font(.pretendardMedium(size: 12))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.tag, in: Capsule())
                            .lineLimit(1)
                    }
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60)
    }
}

#Preview {
    let samplePlaylist = MolioPlaylist(id: UUID(), name: "카공할 때 듣는 플리", createdAt: .now, musicISRCs: [], filters: ["팝", "락", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈", "재즈"])
    
    CommunityPagePlaylistCellView(playlist: samplePlaylist)
        .background(Color.black)
        .foregroundStyle(.white)
}
