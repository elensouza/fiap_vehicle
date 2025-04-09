import Foundation

struct CreateVehicleUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute(payload: Vehicle) async throws -> Vehicle {
        try await repository.create(payload)
        return payload
    }
}
