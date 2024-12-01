enum ProfileType {
    case me
    case friend(userID: String, isFollowing: FollowRelationType)
}
