import Foundation

struct SellVehicleUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute(payload: Sale) async throws {
        guard var vehicle = try await repository.find(by: payload.vehicleId) else {
            throw VehicleError.notFound
        }

        guard vehicle.status == .available else {
            throw VehicleError.alreadySold
        }

        vehicle.documentBuyer = payload.documentBuyer
        vehicle.dateSold = Date.now

        try await repository.update(vehicle)
    }
}
