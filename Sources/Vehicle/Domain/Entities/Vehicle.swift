import Foundation

struct Vehicle {
    let id: UUID
    var brand: String
    var model: String
    var year: Int
    var color: String
    var price: Double
    var sold: Bool
    var documentBuyer: String?
    var dateSold: Date?
}
