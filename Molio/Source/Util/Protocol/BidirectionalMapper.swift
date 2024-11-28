protocol BidirectionalMapper {
    associatedtype Entity
    associatedtype DTO

    static func map(from: Entity) -> DTO
    static func map(from: DTO) -> Entity
}
