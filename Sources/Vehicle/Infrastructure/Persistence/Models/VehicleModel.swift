import Foundation
import Fluent

final class VehicleModel: Model, @unchecked Sendable {
    static let schema = "vehicles"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "brand")
    var brand: String

    @Field(key: "model")
    var model: String

    @Field(key: "year")
    var year: Int

    @Field(key: "color")
    var color: String

    @Field(key: "price")
    var price: Double

    @Field(key: "sold")
    var sold: Bool

    @Field(key: "document_buyer")
    var documentBuyer: String?

    @Timestamp(key: "date_sold", on: .none)
    var dateSold: Date?

    init(
        id: UUID? = nil,
        brand: String,
        model: String,
        year: Int,
        color: String,
        price: Double,
        sold: Bool,
        documentBuyer: String? = nil,
        dateSold: Date? = nil
    ) {
        self.id = id
        self.brand = brand
        self.model = model
        self.year = year
        self.color = color
        self.price = price
        self.sold = sold
        self.documentBuyer = documentBuyer
        self.dateSold = dateSold
    }

    init() { }
}
