import Foundation

enum PaymentError: Error {
    case invalidStatus
    case notFound(_ message: String)
    case badRequest(_ message: String)
    case conflict(_ message: String)
    case internalServerError(_ message: String)

    var localizedDescription: String {
        switch self {
        case .invalidStatus:
            "Invalid payment status"
        case .notFound(let message), .badRequest(let message), .conflict(let message), .internalServerError(let message):
            message
        }
    }
}
