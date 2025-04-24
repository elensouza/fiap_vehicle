import Foundation

struct UpdateVehicleUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute(payload: Vehicle) async throws {
        guard var vehicle = try await repository.find(by: payload.id) else {
            throw VehicleError.notFound
        }

        guard vehicle.status == .available else {
            throw VehicleError.alreadySold
        }

        vehicle.brand = payload.brand
        vehicle.model = payload.model
        vehicle.year = payload.year
        vehicle.color = payload.color
        vehicle.price = payload.price

        try await repository.update(vehicle)
    }
}
