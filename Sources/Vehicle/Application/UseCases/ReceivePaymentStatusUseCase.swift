import Foundation

struct ReceivePaymentStatusUseCase: @unchecked Sendable {
    private let vehicleRepository: any VehicleRepository

    init(repository: any VehicleRepository) {
        self.vehicleRepository = repository
    }

    func execute(payload: Payment) async throws {
        guard var vehicle = try await vehicleRepository.find(by: payload.paymentId) else {
            throw VehicleError.notFound
        }

        guard vehicle.documentBuyer != nil else {
            throw VehicleError.mustStartSelling
        }

        guard vehicle.status == .available else {
            throw VehicleError.alreadySold
        }

        switch payload.status {
        case .paid:
            vehicle.status = .sold
            vehicle.dateSold = payload.receivedAt
        case .cancelled:
            vehicle.status = .available
            vehicle.dateSold = nil
            vehicle.documentBuyer = nil
        }

        try await vehicleRepository.update(vehicle)
    }
}
