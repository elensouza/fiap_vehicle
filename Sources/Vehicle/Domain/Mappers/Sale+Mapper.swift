import Foundation

extension Components.Schemas.SalePayload {
    func toEntity() -> Sale {
        Sale(
            id: UUID(uuidString: id)!, // TODO: Remove force unwrap
            documentBuyer: documentBuyer
        )
    }
}
