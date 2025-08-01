# TraceFlow 🔍📱

> **Transparent Supply Chain Tracking with QR Code Integration on Stacks Blockchain**

TraceFlow is a decentralized supply chain transparency solution built on the Stacks blockchain using Clarity smart contracts. It enables manufacturers, suppliers, and distributors to create immutable records of product journey from creation to consumer delivery, now enhanced with integrated QR code generation and verification for seamless physical product tracking.

## 🎯 Overview

TraceFlow addresses the critical need for supply chain transparency in manufacturing by providing:

- **Product Registration**: Manufacturers can register products with unique identifiers and auto-generated QR codes
- **QR Code Integration**: Automatic QR code generation for each product with blockchain-verified authenticity
- **QR Code Scanning**: Track product scans with location and timestamp data
- **Stage Tracking**: Each supply chain stage is recorded with location, handler, and timestamp
- **Handler Authorization**: Only authorized entities can add supply chain stages
- **Verification System**: Contract owner can verify stages and invalidate QR codes for security
- **Scan History**: Complete audit trail of all QR code scans with location tracking
- **Transparency**: All data is publicly accessible and immutable

## 🚀 Features

### Core Functionality
- **Product Registration**: Register new products with batch numbers, manufacturing details, and auto-generated QR codes
- **QR Code Management**: Generate unique, blockchain-verified QR codes for each product
- **QR Code Scanning**: Scan products to verify authenticity and track location history
- **Supply Chain Stages**: Add stages like "Raw Material Sourcing", "Manufacturing", "Quality Control", "Shipping", "Distribution"
- **Handler Management**: Authorize trusted supply chain participants
- **Stage Verification**: Verify supply chain stages for authenticity
- **Scan Analytics**: Track QR code scan frequency and locations
- **Security Controls**: Invalidate QR codes for recalls or security incidents
- **Transparency**: Query product history, QR scan data, and current status

### Smart Contract Features
- **Auto-Generated QR Codes**: Unique QR codes generated using cryptographic hashing for each product
- **QR Code Verification**: Blockchain-based verification system to prevent counterfeiting
- **Scan Tracking**: Complete audit trail of all QR code scans with timestamps and locations
- **Immutable Records**: All supply chain and QR scan data is permanently stored on blockchain
- **Access Control**: Role-based permissions for different participants
- **Data Integrity**: Prevents tampering with supply chain and QR code information
- **Real-time Tracking**: Track products and scan activity in real-time across the supply chain
- **Security Controls**: Ability to invalidate compromised QR codes

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

### Register a Product (with QR Code)
```clarity
;; Returns both product-id and qr-code-hash
(contract-call? .traceflow register-product "Organic Cotton T-Shirt" "BATCH-2024-001")
```

### Scan QR Code
```clarity
(contract-call? .traceflow scan-qr-code 0x1234567890abcdef... "New York Retail Store")
```

### Verify QR Code Authenticity
```clarity
(contract-call? .traceflow verify-qr-code 0x1234567890abcdef... u1)
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

### Get QR Code Information
```clarity
(contract-call? .traceflow get-qr-code-info 0x1234567890abcdef...)
```

### Get Product by QR Code
```clarity
(contract-call? .traceflow get-product-by-qr 0x1234567890abcdef...)
```

## 🏗️ Contract Architecture

### Data Structures
- **Products**: Store product information including manufacturer, name, batch number, and QR code hash
- **QR Code Registry**: Maps QR code hashes to product IDs with scan tracking and validity status
- **QR Scan History**: Complete audit trail of all QR code scans with scanner, timestamp, and location
- **Supply Chain Stages**: Track each stage with handler, location, timestamp, and data
- **Authorized Handlers**: Manage authorized supply chain participants
- **Product Stage Count**: Track number of stages per product

### Key Functions
- `register-product`: Register new products with auto-generated QR codes
- `scan-qr-code`: Scan QR codes and record scan activity with location
- `verify-qr-code`: Verify QR code authenticity against product ID
- `invalidate-qr-code`: Invalidate QR codes for security or recalls
- `authorize-handler`: Authorize supply chain participants
- `add-supply-chain-stage`: Add new supply chain stages
- `verify-stage`: Verify stages for authenticity
- `get-product`: Retrieve product information
- `get-qr-code-info`: Get QR code details and scan statistics
- `get-product-by-qr`: Retrieve product information using QR code
- `get-qr-scan-history`: Get detailed scan history for QR codes

## 🔐 Security Features

- **QR Code Security**: Cryptographically generated QR codes prevent counterfeiting
- **Scan Auditing**: Complete audit trail of all QR code scanning activity
- **Access Control**: Only authorized handlers can add stages
- **Owner Privileges**: Contract owner can verify stages, authorize handlers, and invalidate QR codes
- **Input Validation**: Comprehensive input validation prevents invalid data
- **Immutable Records**: Blockchain ensures data cannot be tampered with
- **Anti-Counterfeiting**: QR code verification system prevents fake products

## 🧪 Testing

Run the test suite:
```bash
clarinet test
```

The test suite covers:
- Product registration with QR code generation
- QR code scanning and verification
- QR code invalidation and security controls
- Handler authorization
- Supply chain stage addition
- Access control verification
- Data integrity checks
- Anti-counterfeiting measures

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- Stacks Foundation for the blockchain infrastructure
- Clarity language for secure smart contract development
- Manufacturing industry partners for requirements and feedback

---

**Built with ❤️ for Supply Chain Transparency**
