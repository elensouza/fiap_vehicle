import Foundation

extension Components.Schemas.SalePayload {
    func toEntity() -> Sale {
        Sale(
            vehicleId: UUID(uuidString: vehicleId)!, // TODO: Remove force unwrap
            documentBuyer: documentBuyer
        )
    }
}
