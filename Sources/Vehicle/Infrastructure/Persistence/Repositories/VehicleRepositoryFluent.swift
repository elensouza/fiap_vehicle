import Foundation
import Fluent
import PostgresNIO

struct VehicleRepositoryFluent: VehicleRepository {
    private let db: any Database
    private let logger: Logger

    init(db: any Database, logger: Logger) {
        self.db = db
        self.logger = logger
    }

    func create(_ vehicle: Vehicle) async throws {
        try await perform {
            try await vehicle.toModel().create(on: db)
        }
    }

    func find(by id: UUID) async throws -> Vehicle? {
        try await perform {
            try await VehicleModel.find(id, on: db)?.toEntity()
        }
    }

    func update(_ vehicle: Vehicle) async throws {
        try await perform {
            guard let model = try await VehicleModel.find(vehicle.id, on: db) else {
                throw RepositoryError.entityNotFound
            }

            model.brand = vehicle.brand
            model.model = vehicle.model
            model.year = vehicle.year
            model.color = vehicle.color
            model.price = vehicle.price
            model.status = vehicle.status.rawValue
            model.documentBuyer = vehicle.documentBuyer
            model.dateSold = vehicle.dateSold
            model.datePayment = vehicle.datePayment

            try await model.update(on: db)
        }
    }

    func listAvailable() async throws -> [Vehicle] {
        try await perform {
            try await VehicleModel.query(on: db)
                .filter(\.$status == VehicleStatus.available.rawValue)
                .sort(\.$price, .ascending)
                .all()
                .map { $0.toEntity() }
        }
    }

    func listSold() async throws -> [Vehicle] {
        try await perform {
            try await VehicleModel.query(on: db)
                .filter(\.$status == VehicleStatus.sold.rawValue)
                .sort(\.$price, .ascending)
                .all()
                .map {
                    $0.toEntity()
                }
        }
    }
}

private extension VehicleRepositoryFluent {
    func perform<T>(_ operation: () async throws -> T) async throws -> T {
        do {
            return try await operation()
        } catch let error as FluentError {
            logger.error("\(error.debugDescription)")
            throw error.toRepositoryError()
        } catch let error as PSQLError {
            logger.error("\(error.serverInfo?[PSQLError.ServerInfo.Field.message] ?? error.debugDescription)")
            throw RepositoryError.unknown(message: error.localizedDescription)
        } catch {
            logger.error("\(error.localizedDescription)")
            throw RepositoryError.unknown(message: error.localizedDescription)
        }
    }
}

private extension FluentError {
    func toRepositoryError() -> RepositoryError {
        switch self {
        case .idRequired:
            return .missingID
        case .invalidField(let name, _, _):
            return .invalidField(name: name)
        case .missingField(let name):
            return .missingField(name: name)
        case .relationNotLoaded(let name):
            return .relationshipNotLoaded(name: name)
        case .missingParent:
            return .invalidRelationship
        case .noResults:
            return .entityNotFound
        }
    }
}
