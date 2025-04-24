import Foundation

enum PaymentError: Error {
    case invalidStatus
    case repositoryFailure(_ message: String)

    var localizedDescription: String {
        switch self {
        case .invalidStatus:
            return "Invalid payment status"
        case .repositoryFailure(let message):
            return message
        }
    }
}
