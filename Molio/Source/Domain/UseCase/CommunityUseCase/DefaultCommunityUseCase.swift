final class DefaultCommunityUseCase: CommunityUseCase {
    private let service: FollowRelationService
    
    init(
        service: FollowRelationService
    ) {
        self.service = service
    }
}
