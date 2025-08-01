# TraceFlow 🔍

> **Transparent Supply Chain Tracking on Stacks Blockchain**

TraceFlow is a decentralized supply chain transparency solution built on the Stacks blockchain using Clarity smart contracts. It enables manufacturers, suppliers, and distributors to create immutable records of product journey from creation to consumer delivery.

## 🎯 Overview

TraceFlow addresses the critical need for supply chain transparency in manufacturing by providing:

- **Product Registration**: Manufacturers can register products with unique identifiers
- **Stage Tracking**: Each supply chain stage is recorded with location, handler, and timestamp
- **Handler Authorization**: Only authorized entities can add supply chain stages
- **Verification System**: Contract owner can verify stages for authenticity
- **Transparency**: All data is publicly accessible and immutable

## 🚀 Features

### Core Functionality
- **Product Registration**: Register new products with batch numbers and manufacturing details
- **Supply Chain Stages**: Add stages like "Raw Material Sourcing", "Manufacturing", "Quality Control", "Shipping", "Distribution"
- **Handler Management**: Authorize trusted supply chain participants
- **Stage Verification**: Verify supply chain stages for authenticity
- **Transparency**: Query product history and current status

### Smart Contract Features
- **Immutable Records**: All supply chain data is permanently stored on blockchain
- **Access Control**: Role-based permissions for different participants
- **Data Integrity**: Prevents tampering with supply chain information
- **Real-time Tracking**: Track products in real-time across the supply chain

## 📋 Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Basic understanding of Clarity smart contracts
- Stacks wallet for testing

## 🛠️ Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd traceflow
```

2. Install dependencies:
```bash
clarinet requirements
```

3. Run tests:
```bash
clarinet test
```

4. Check contract:
```bash
clarinet check
```

## 📖 Usage

### Register a Product
```clarity
(contract-call? .traceflow register-product "Organic Cotton T-Shirt" "BATCH-2024-001")
```

### Authorize a Handler
```clarity
(contract-call? .traceflow authorize-handler 'ST1SUPPLIER123 "Cotton Supplier Co." "Raw Material Supplier")
```

### Add Supply Chain Stage
```clarity
(contract-call? .traceflow add-supply-chain-stage u1 "Raw Material Sourcing" "Gujarat, India" "Organic cotton sourced from certified farms")
```

### Get Product Information
```clarity
(contract-call? .traceflow get-product u1)
```

## 🏗️ Contract Architecture

### Data Structures
- **Products**: Store product information including manufacturer, name, batch number
- **Supply Chain Stages**: Track each stage with handler, location, timestamp, and data
- **Authorized Handlers**: Manage authorized supply chain participants
- **Product Stage Count**: Track number of stages per product

### Key Functions
- `register-product`: Register new products
- `authorize-handler`: Authorize supply chain participants
- `add-supply-chain-stage`: Add new supply chain stages
- `verify-stage`: Verify stages for authenticity
- `get-product`: Retrieve product information
- `get-supply-chain-stage`: Get specific stage information

## 🔐 Security Features

- **Access Control**: Only authorized handlers can add stages
- **Owner Privileges**: Contract owner can verify stages and authorize handlers
- **Input Validation**: Comprehensive input validation prevents invalid data
- **Immutable Records**: Blockchain ensures data cannot be tampered with

## 🧪 Testing

Run the test suite:
```bash
clarinet test
```

The test suite covers:
- Product registration
- Handler authorization
- Supply chain stage addition
- Access control verification
- Data integrity checks

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
