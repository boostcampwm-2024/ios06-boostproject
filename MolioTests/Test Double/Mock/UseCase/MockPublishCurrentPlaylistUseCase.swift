import Combine
@testable import Molio

final class MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    
    // 원하는 MolioPlaylist을 설정할 수 있는 프로퍼티
    var mockPlaylist: MolioPlaylist?
    
    // 데이터를 발행하기 위한 퍼블리셔
    private var subject: CurrentValueSubject<MolioPlaylist?, Never>
    
    // 초기화 시 mockPlaylist를 설정하고 subject를 초기화
    init(mockPlaylist: MolioPlaylist? = nil) {
        self.mockPlaylist = mockPlaylist
        self.subject = CurrentValueSubject<MolioPlaylist?, Never>(mockPlaylist)
    }
    
    // 프로토콜의 execute 메서드 구현
    func execute() -> AnyPublisher<MolioPlaylist?, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    // 테스트 중에 mockPlaylist를 업데이트할 수 있는 메서드
    func updatePlaylist(_ playlist: MolioPlaylist?) {
        self.mockPlaylist = playlist
        subject.send(playlist)
    }
}
