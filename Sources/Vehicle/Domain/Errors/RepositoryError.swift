import Foundation

enum RepositoryError: Error {
    case missingID
    case entityNotFound
    case invalidField(name: String)
    case missingField(name: String)
    case relationshipNotLoaded(name: String)
    case invalidRelationship
    case unknown(message: String)
}
