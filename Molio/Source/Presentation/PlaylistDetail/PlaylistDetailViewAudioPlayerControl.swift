import SwiftUI

struct PlaylistDetailViewAudioPlayerControl: View {
    // TODO: 현재 플레이리스트들의 노래들을 받아오는 유즈케이스 의존성 주입 후 사용
//    init( )
    

    // TODO: AudioPlayer에 대핸 UseCase를 버튼에서 실행하기
    var body: some View {
        HStack {
            Spacer()

            Button {

            } label: {
                Image.molioRegular(systemName: "backward.fill", size: 24, color: .main)
            }

            Spacer()

            Button {

            } label: {
                Image.molioRegular(systemName: "play.fill", size: 24, color: .main)
            }

            Spacer()

            Button {

            } label: {
                Image.molioRegular(systemName: "forward.fill", size: 24, color: .main)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray, in: .capsule)
    }
}

#Preview {
    ZStack {
        Color.black
        PlaylistDetailViewAudioPlayerControl()
            .font(.title)
            .frame(maxHeight: 66)
    }
}
