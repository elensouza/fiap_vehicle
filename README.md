# 🚗 Plataforma de Revenda de Veículos

Este projeto é uma API RESTful desenvolvida em [Swift](https://www.swift.org/) com [Vapor](https://vapor.codes/) que permite gerenciar uma plataforma de revenda de veículos. Ela segue os princípios da Clean Architecture e SOLID, com documentação automatizada via OpenAPI/Swagger e infraestrutura orquestrada com Kubernetes.

---

## 📦 Funcionalidades

- Cadastrar veículos (marca, modelo, ano, cor, preço)
- Editar dados de veículos
- Efetuar a venda de um veículo (CPF do comprador, data da venda)
- Listar veículos disponíveis para venda (ordenado por preço, do mais barato ao mais caro)
- Listar veículos vendidos (ordenado por preço, do mais barato ao mais caro)
- Webhook para atualização do status de pagamento (efetuado ou cancelado)

---

## 🛠️ Tecnologias

- Swift + Vapor
- PostgreSQL + Fluent ORM
- OpenAPI (Swagger)
- Docker / Docker Compose
- Kubernetes
- Clean Architecture (prescritiva)

---

## 📁 Estrutura do Projeto

```bash
.
├── Dockerfile
├── Package.resolved
├── Package.swift
├── Public
│   ├── favicon.ico
│   ├── vehicle
│   │   ├── openapi.yaml
│   │   └── swagger.html
│   └── webhook
│       ├── openapi.yaml
│       └── swagger.html
├── README.md
├── Sources
│   ├── Vehicle
│   │   ├── Application
│   │   │   └── UseCases
│   │   │       ├── CreateVehicleUseCase.swift
│   │   │       ├── ListAvailableVehiclesUseCase.swift
│   │   │       ├── ListSoldVehiclesUseCase.swift
│   │   │       ├── ReceivePaymentStatusUseCase.swift
│   │   │       ├── SellVehicleUseCase.swift
│   │   │       └── UpdateVehicleUseCase.swift
│   │   ├── Domain
│   │   │   ├── Entities
│   │   │   │   ├── Payment.swift
│   │   │   │   ├── Sale.swift
│   │   │   │   └── Vehicle.swift
│   │   │   ├── Errors
│   │   │   │   ├── PaymentError.swift
│   │   │   │   ├── RepositoryError.swift
│   │   │   │   └── VehicleError.swift
│   │   │   ├── Mappers
│   │   │   │   ├── Payment+Mapper.swift
│   │   │   │   ├── Sale+Mapper.swift
│   │   │   │   └── Vehicle+Mapper.swift
│   │   │   └── Repositories
│   │   │       └── VehicleRepository.swift
│   │   ├── Infrastructure
│   │   │   └── Persistence
│   │   │       ├── Migrations
│   │   │       │   └── CreateVehicle.swift
│   │   │       ├── Models
│   │   │       │   └── VehicleModel.swift
│   │   │       └── Repositories
│   │   │           └── VehicleRepositoryFluent.swift
│   │   ├── Interfaces
│   │   │   └── HTTP
│   │   │       ├── Handlers
│   │   │       │   └── VehicleHandler.swift
│   │   │       └── routes.swift
│   │   ├── configure.swift
│   │   ├── entrypoint.swift
│   │   ├── openapi-generator-config.yaml
│   │   └── openapi.yaml
│   └── Webhook
│       ├── Application
│       │   └── UseCases
│       │       └── ReceivePaymentStatusUseCase.swift
│       ├── Domain
│       │   ├── Entities
│       │   │   ├── Payment.swift
│       │   │   └── PaymentStatus.swift
│       │   ├── Errors
│       │   │   └── PaymentError.swift
│       │   ├── Mappers
│       │   │   └── Payment+Mapper.swift
│       │   └── Repositories
│       │       └── PaymentRepository.swift
│       ├── Infrastructure
│       │   └── Persistence
│       │       └── Repositories
│       │           └── PaymentRepositoryHTTP.swift
│       ├── Interfaces
│       │   └── HTTP
│       │       ├── DTOs
│       │       │   └── ErrorResponse.swift
│       │       ├── Handlers
│       │       │   └── WebhookHandler.swift
│       │       └── routes.swift
│       ├── configure.swift
│       ├── entrypoint.swift
│       ├── openapi-generator-config.yaml
│       └── openapi.yaml
├── docker-compose.yml
└── kubernetes.yaml
```

---

## 🚀 Como rodar localmente com Docker Compose

```bash
docker compose up
```

A aplicação será iniciada em `http://localhost:8080`.

---

## ☸️ Como rodar com Kubernetes (Minikube)

1. Suba o Minikube com:

```bash
minikube start
```

2. Construa a imagem local:

```bash
docker build -t vehicle:latest .
minikube image load vehicle:latest
```

3. Aplique os manifests:

```bash
kubectl apply -f kubernetes.yaml
```

4. Acesse a aplicação:

```bash
minikube service app-service
minikube service webhook-service
```

---

## 🧪 Testes de API

Recomenda-se o uso de ferramentas como Postman ou Swagger UI (gerado automaticamente) para testar os endpoints.

---

## 🧾 Documentação da API

A documentação dos endpoints segue o padrão OpenAPI 3.0 (Swagger) e está disponível em `/swagger`.

---

## 🎥 Vídeo de Demonstração

> https://youtu.be/1iI3A-t_seM

---

## 📁 Repositório

> https://github.com/elensouza/fiap_vehicle

---

## 👨‍💻 Autor
Elen de Souza - RM351136

Desenvolvido para o Tech Challenge SOAT – PósTech
