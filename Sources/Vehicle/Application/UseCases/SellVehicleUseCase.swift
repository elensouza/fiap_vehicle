import Foundation

struct SellVehicleUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute(payload: Sale) async throws {
        guard var vehicle = try await repository.find(by: payload.id) else {
            throw VehicleError.notFound
        }

        vehicle.documentBuyer = payload.documentBuyer

        try await repository.update(vehicle)
    }
}
