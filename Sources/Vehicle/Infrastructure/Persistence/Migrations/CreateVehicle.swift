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
            .field("price", .double, .required)
            .field("status", .string, .required)
            .field("document_buyer", .string)
            .field("date_sold", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(VehicleModel.schema).delete()
    }
}
