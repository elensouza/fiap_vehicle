import OpenAPIRuntime
import OpenAPIVapor
import Fluent
import Vapor
import FluentKit

struct VehicleHandler: APIProtocol {
    private let createVehicleUseCase: CreateVehicleUseCase
    private let updateVehicleUseCase: UpdateVehicleUseCase
    private let listAvailableVehiclesUseCase: ListAvailableVehiclesUseCase
    private let listSoldVehiclesUseCase: ListSoldVehiclesUseCase
    private let sellVehicleUseCase: SellVehicleUseCase
    private let receivePaymentStatusUseCase: ReceivePaymentStatusUseCase

    init(repository: any VehicleRepository) {
        self.createVehicleUseCase = CreateVehicleUseCase(repository: repository)
        self.updateVehicleUseCase = UpdateVehicleUseCase(repository: repository)
        self.listAvailableVehiclesUseCase = ListAvailableVehiclesUseCase(repository: repository)
        self.listSoldVehiclesUseCase = ListSoldVehiclesUseCase(repository: repository)
        self.sellVehicleUseCase = SellVehicleUseCase(repository: repository)
        self.receivePaymentStatusUseCase = ReceivePaymentStatusUseCase(repository: repository)
    }

    func createVehicle(_ input: Operations.CreateVehicle.Input) async throws -> Operations.CreateVehicle.Output {
        guard case .json(let dto) = input.body else {
            return .badRequest(.init(body: .json(.init(message: "Invalid body"))))
        }

        do {
            let vehicle = dto.toEntity()
            let response = try await createVehicleUseCase.execute(payload: vehicle)
            return .ok(.init(body: .json(response.toResponse())))
        } catch let error as RepositoryError {
            return .unprocessableContent(.init(body: .json(.init(message: error.localizedDescription))))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }

    func updateVehicle(_ input: Operations.UpdateVehicle.Input) async throws -> Operations.UpdateVehicle.Output {
        guard let id = UUID(uuidString: input.path.id) else {
            return .badRequest(.init(body: .json(.init(message: "Invalid UUID format"))))
        }

        guard case .json(let dto) = input.body else {
            return .badRequest(.init(body: .json(.init(message: "Invalid body"))))
        }

        do {
            try await updateVehicleUseCase.execute(payload: dto.toEntity(with: id))
            return .ok
        } catch VehicleError.notFound, RepositoryError.entityNotFound {
            return .notFound(.init(body: .json(.init(message: "Vehicle not found"))))
        } catch VehicleError.alreadySold {
            return .unprocessableContent(.init(body: .json(.init(message: "Vehicle already sold"))))
        } catch let error as RepositoryError {
            return .unprocessableContent(.init(body: .json(.init(message: error.localizedDescription))))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }

    func listAvailableVehicles(_ input: Operations.ListAvailableVehicles.Input) async throws -> Operations.ListAvailableVehicles.Output {
        do {
            let vehicles = try await listAvailableVehiclesUseCase.execute()
            return .ok(.init(body: .json(vehicles.map { $0.toResponse() })))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }

    func listSoldVehicles(_ input: Operations.ListSoldVehicles.Input) async throws -> Operations.ListSoldVehicles.Output {
        do {
            let vehicles = try await listSoldVehiclesUseCase.execute()
            return .ok(.init(body: .json(vehicles.map { $0.toResponse() })))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }

    func sellVehicle(_ input: Operations.SellVehicle.Input) async throws -> Operations.SellVehicle.Output {
        guard case .json(let dto) = input.body else {
            return .badRequest(.init(body: .json(.init(message: "Invalid body"))))
        }

        do {
            try await sellVehicleUseCase.execute(payload: dto.toEntity())
            return .ok
        } catch VehicleError.notFound, RepositoryError.entityNotFound {
            return .notFound(.init(body: .json(.init(message: "Vehicle not found"))))
        } catch let error as RepositoryError {
            return .unprocessableContent(.init(body: .json(.init(message: error.localizedDescription))))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }

    func registerPaymentStatus(_ input: Operations.RegisterPaymentStatus.Input) async throws -> Operations.RegisterPaymentStatus.Output {
        guard case .json(let dto) = input.body else {
            return .badRequest(.init(body: .json(.init(message: "Invalid body"))))
        }

        do {
            try await receivePaymentStatusUseCase.execute(payload: dto.toEntity())
            return .ok
        } catch VehicleError.notFound {
            return .notFound(.init(body: .json(.init(message: "Vehicle not found"))))
        } catch VehicleError.mustStartSelling {
            return .badRequest(.init(body: .json(.init(message: "Vehicle has not started selling yet"))))
        } catch VehicleError.alreadySold {
            return .conflict(.init(body: .json(.init(message: "Vehicle already sold"))))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "Unexpected error"))))
        }
    }
}
