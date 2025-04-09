import Foundation

struct GetVehicleByIdUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute(id: UUID) async throws -> Vehicle {
        guard let vehicle = try await repository.find(by: id) else {
            throw VehicleError.notFound
        }
        return vehicle
    }
}
