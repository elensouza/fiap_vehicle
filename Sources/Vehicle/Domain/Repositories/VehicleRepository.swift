import Foundation

protocol VehicleRepository {
    func create(_ vehicle: Vehicle) async throws
    func find(by id: UUID) async throws -> Vehicle?
    func update(_ vehicle: Vehicle) async throws
    func listAvailable() async throws -> [Vehicle]
    func listSold() async throws -> [Vehicle]
}
