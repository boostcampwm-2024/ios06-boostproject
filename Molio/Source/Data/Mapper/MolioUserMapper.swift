import Foundation

struct MolioUserMapper: BidirectionalMapper {
    typealias Entity = MolioUser
    typealias DTO = MolioUserDTO
    
    static func map(from user: MolioUser) -> MolioUserDTO {
        return MolioUserDTO(
            id: user.id,
            name: user.name,
            profileImageURL: user.profileImageURL?.absoluteString,
            description: user.description
        )
    }
    
    static func map(from dto: MolioUserDTO) -> MolioUser {
        let profileImageURL: URL?
        
        if let urlString = dto.profileImageURL {
            profileImageURL = URL(string: urlString)
        } else {
            profileImageURL = nil
        }
        
        return MolioUser(
            id: dto.id,
            name: dto.name,
            profileImageURL: profileImageURL,
            description: dto.description
        )
    }
}
