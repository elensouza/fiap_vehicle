import Foundation

struct Vehicle {
    let id: UUID
    var brand: String
    var model: String
    var year: Int
    var color: String
    var price: Decimal
    var status: VehicleStatus
    var documentBuyer: String?
    var dateSold: Date?
    var datePayment: Date?
}

enum VehicleStatus: String {
    case available = "AVAILABLE"
    case sold = "SOLD"
}
