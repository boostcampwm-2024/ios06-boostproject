import Photos

final class ExportPlaylistViewModel: ObservableObject {
    let itemHeight: CGFloat = 54.0
    let exportMusicListPageTopPadding: CGFloat = 50.0
    let exportMusicListPageBottomPadding: CGFloat = 72.0
    
    var alertState: AlertType = .successSaveImage
    @Published var isLoadingMusic = true
    @Published var selectedTab = 0
    @Published var showAlert = false
    @Published private(set) var paginatedMusicItems: [[ExportMusicItem]] = []
    
    private let musics: [MolioMusic]
    private var exportMusicItems: [ExportMusicItem] = []
    private let fetchImageUseCase: FetchImageUseCase
    
    var numberOfPages: Int {
        return max(1, paginatedMusicItems.count)
    }
    
    init(musics: [MolioMusic], fetchImageUseCase: FetchImageUseCase) {
        self.musics = musics
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    /// 화면 크기에 맞게 Molio Music을 page에 맞는 모델로 변경하는 메서드
    func updateExportMolioMusics(height: CGFloat) async {
        guard height > 0 else { return }
        let musicItems = await getExportMusicItem()
        
        let viewHeight = height - exportMusicListPageTopPadding - exportMusicListPageBottomPadding
        let itemMaxCountPerPage = Int(viewHeight / itemHeight)
        
        let result = musicItems.reduce(into: [[ExportMusicItem]]()) { result, element in
            if let last = result.last, last.count < itemMaxCountPerPage {
                result[result.count - 1].append(element)
            } else {
                result.append([element])
            }
        }
        
        await MainActor.run {
            paginatedMusicItems = result
            isLoadingMusic = false
        }
    }
    
    /// MolioMusic 타입을 ExportMusicItem타입으로 변경하는 메서드
    private func convertToExportMusicItem(molioMusics: [MolioMusic]) async throws -> [ExportMusicItem] {
        try await withThrowingTaskGroup(of: ExportMusicItem.self) { group in
            for music in molioMusics {
                group.addTask { [weak self] in
                    if let imageURL = music.artworkImageURL {
                        let imageData = try await self?.fetchImageUseCase.execute(url: imageURL)
                        return ExportMusicItem(molioMusic: music, imageData: imageData)
                    } else {
                        return ExportMusicItem(molioMusic: music, imageData: nil)
                    }
                }
            }
            
            var musicItems: [ExportMusicItem] = []
            for try await item in group {
                musicItems.append(item)
            }
            
            return musicItems
        }
    }
    
    /// ExportMusicItem 배열을 가져오는 메서드
    private func getExportMusicItem() async -> [ExportMusicItem] {
        if exportMusicItems.isEmpty {
            do {
                exportMusicItems = try await convertToExportMusicItem(molioMusics: self.musics)
                return exportMusicItems
            } catch {
                return []
            }
        } else {
            return self.exportMusicItems
        }
    }
    
    /// 앨범에 저장할 수 있는 권환을 확인하는 메서드
    func isPhotoLibraryDenied() async -> Bool {
        var isAuthorized = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if isAuthorized == .notDetermined {
            isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        }
        
        return isAuthorized == .denied
    }
    
    enum AlertType {
        case deniedPhotoLibrary
        case emptyMusicItems
        case successSaveImage
        case failureSaveImage
        
        var title: String {
            switch self {
            case .deniedPhotoLibrary:
                "사진 접근 권한이 필요합니다"
            case .emptyMusicItems:
                "플레이리스트가 비어 있습니다"
            case .successSaveImage:
                "저장이 완료되었습니다"
            case .failureSaveImage:
                "저장에 실패했습니다"
            }
        }
        
        var message: String {
            switch self {
            case .deniedPhotoLibrary:
                "사진을 저장하려면 사진 접근 권한이 필요합니다. 설정에서 접근 권한을 허용해 주세요. 설정 > Molio > 사진 접근 허용"
            case .emptyMusicItems:
                "사진에 저장할 음악이 없습니다.\n메인화면에서 취향에 맞는 음악을 추가해 주세요."
            case .successSaveImage:
                "Molio 이미지가 사진에 성공적으로 저장되었습니다."
            case .failureSaveImage:
                "이미지를 저장하는 중 오류가 발생했습니다. 다시 시도해 주세요."
            }
        }
    }
}
