import Foundation

extension Vehicle {
    func toModel() -> VehicleModel {
        VehicleModel(
            id: id,
            brand: brand,
            model: model,
            year: year,
            color: color,
            price: price,
            status: status.rawValue,
            documentBuyer: documentBuyer,
            dateSold: dateSold,
            datePayment: datePayment
        )
    }

    func toResponse() -> Components.Schemas.VehicleResponse {
        Components.Schemas.VehicleResponse(
            id: id.uuidString,
            brand: brand,
            model: model,
            year: year,
            color: color,
            price: (price as NSDecimalNumber).doubleValue,
            status: .init(rawValue: status.rawValue) ?? .available,
            documentBuyer: documentBuyer,
            dateSold: dateSold?.ISO8601Format(),
            datePayment: datePayment?.ISO8601Format()
        )
    }
}

extension VehicleModel {
    func toEntity() -> Vehicle {
        Vehicle(
            id: id ?? UUID(),
            brand: brand,
            model: model,
            year: year,
            color: color,
            price: price,
            status: VehicleStatus(rawValue: self.status) ?? .available,
            documentBuyer: documentBuyer,
            dateSold: dateSold,
            datePayment: datePayment
        )
    }
}

extension Components.Schemas.VehiclePayload {
    func toEntity(with id: UUID = UUID()) -> Vehicle {
        Vehicle(
            id: id,
            brand: self.brand,
            model: self.model,
            year: self.year,
            color: self.color,
            price: Decimal(self.price),
            status: .available,
            documentBuyer: nil,
            dateSold: nil,
            datePayment: nil
        )
    }
}
