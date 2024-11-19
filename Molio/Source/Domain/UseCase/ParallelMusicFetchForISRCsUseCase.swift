protocol ParallelMusicFetchForISRCsUseCase {
    func execute(isrcs: [String]) async throws -> [RandomMusic]
}
