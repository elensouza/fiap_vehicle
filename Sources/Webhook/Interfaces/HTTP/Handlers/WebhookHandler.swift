import OpenAPIRuntime
import OpenAPIVapor
import Vapor

struct WebhookHandler: APIProtocol {
    private let receivePaymentStatusUseCase: ReceivePaymentStatusUseCase

    init(repository: any PaymentRepository) {
        self.receivePaymentStatusUseCase = ReceivePaymentStatusUseCase(repository: repository)
    }

    func receivePaymentStatus(_ input: Operations.ReceivePaymentStatus.Input) async throws -> Operations.ReceivePaymentStatus.Output {
        guard case .json(let dto) = input.body else {
            return .badRequest(.init(body: .json(.init(message: "Invalid body"))))
        }

        do {
            let entity = try dto.toEntity()
            try await receivePaymentStatusUseCase.execute(payload: entity)
            return .ok
        } catch PaymentError.invalidStatus {
            return .unprocessableContent(.init(body: .json(.init(message: "Invalid payment status"))))
        } catch PaymentError.notFound(let message) {
            return .notFound(.init(body: .json(.init(message: "\(message)"))))
        } catch PaymentError.badRequest(let message) {
            return .badRequest(.init(body: .json(.init(message: "\(message)"))))
        } catch PaymentError.conflict(let message) {
            return .conflict(.init(body: .json(.init(message: "\(message)"))))
        } catch {
            return .internalServerError(.init(body: .json(.init(message: "\(error.localizedDescription)"))))
        }
    }
}
