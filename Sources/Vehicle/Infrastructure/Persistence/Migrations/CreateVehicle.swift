import Foundation
import Fluent

struct CreateVehicle: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(VehicleModel.schema)
            .id()
            .field("brand", .string, .required)
            .field("model", .string, .required)
            .field("year", .int, .required)
            .field("color", .string, .required)
            .field("price", .sql(unsafeRaw: "NUMERIC(7,2)"), .required)
            .field("status", .string, .required)
            .field("document_buyer", .string)
            .field("date_sold", .datetime)
            .field("date_payment", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(VehicleModel.schema).delete()
    }
}
