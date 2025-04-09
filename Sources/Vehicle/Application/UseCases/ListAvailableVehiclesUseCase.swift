import Foundation

struct ListAvailableVehiclesUseCase: @unchecked Sendable {
    private let repository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Vehicle] {
        try await repository.listAvailable()
    }
}
