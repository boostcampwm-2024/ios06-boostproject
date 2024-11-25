import Foundation

/// 내 molio 내보내기에 사용되는 Music Item Model입니다.
struct ExportMusicItem {
    /// 노래 제목
    let title: String
    
    /// 아티스트 이름
    let artistName: String
        
    /// 앨범 아트워크 이미지
    let artworkImageData: Data?
    
    let uuid: UUID
    
    init(molioMusic: MolioMusic, imageData: Data?) {
        self.title = molioMusic.title
        self.artistName = molioMusic.artistName
        self.artworkImageData = imageData
        self.uuid = UUID()
    }
}
