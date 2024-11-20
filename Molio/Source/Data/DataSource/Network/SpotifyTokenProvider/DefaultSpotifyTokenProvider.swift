import Foundation

final class DefaultSpotifyTokenProvider: SpotifyTokenProvider {
    private let networkProvider: NetworkProvider
    private var accessToken: String?
    private var expireTime: Date?
    
    private var isTokenExpiringSoon: Bool {
        guard let expireTime else { return true }
        let now = Date.now
        let remainingSecond = Int(expireTime.timeIntervalSince(now))
        return remainingSecond < 300
    }
    
    init(
        networkProvider: NetworkProvider = DIContainer.shared.resolve()
    ) {
        self.networkProvider = networkProvider
    }
    
    /// access token 불러오기
    /// - accessToken이 없거나, 토큰 만료 시간까지 5분보다 적게 남았을 경우(or 이미 만료됐을 경우) => 토큰 새로 발급
    /// - 그렇지 않을 경우 => 기존 토큰 그대로 반환
    func getAccessToken() async throws -> String {
        guard let accessToken = accessToken,
              !isTokenExpiringSoon else {
            return try await requestNewAccessToken()
        }
        return accessToken
    }
    
    /// 새로운 access token 요청
    private func requestNewAccessToken() async throws -> String {
        do {
            let endPoint = SpotifyAuthorizationAPI.createAccessToken
            let responseDTO: SpotifyAccessTokenResponseDTO = try await networkProvider.request(endPoint)
            let newAccessToken = responseDTO.accessToken
            updateAccessToken(to: newAccessToken, expirationSecond: responseDTO.expiresIn)
            return newAccessToken
        } catch {
            throw SpotifyTokenProviderError.failedToCreateToken
        }
    }
    
    /// 새로운 access token 정보로 업데이트
    /// - `accessToken` : 새로 생성한 토큰으로 변경
    /// - `expireTime` : 새로 생성한 토큰의 만료예정시간으로 변경
    private func updateAccessToken(to newToken: String, expirationSecond: Int) {
        let expireTime = Date.now.addingTimeInterval(Double(expirationSecond))
        self.accessToken = newToken
        self.expireTime = expireTime
    }
}
