# TraceFlow 🔍📱🌡️

> **Transparent Supply Chain Tracking with QR Code Integration and IoT Sensor Monitoring on Stacks Blockchain**

TraceFlow is a decentralized supply chain transparency solution built on the Stacks blockchain using Clarity smart contracts. It enables manufacturers, suppliers, and distributors to create immutable records of product journey from creation to consumer delivery, now enhanced with integrated QR code generation, verification, and real-time IoT sensor monitoring for comprehensive environmental and location tracking.

## 🎯 Overview

TraceFlow addresses the critical need for supply chain transparency in manufacturing by providing:

- **Product Registration**: Manufacturers can register products with unique identifiers and auto-generated QR codes
- **QR Code Integration**: Automatic QR code generation for each product with blockchain-verified authenticity
- **QR Code Scanning**: Track product scans with location and timestamp data
- **IoT Sensor Integration**: Connect with temperature, humidity, and location sensors for real-time monitoring
- **Environmental Monitoring**: Track temperature and humidity conditions throughout the supply chain
- **Sensor Data Analytics**: Historical tracking of environmental conditions and sensor readings
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

### IoT Sensor Features
- **Sensor Registration**: Register IoT sensors with type, location, and ownership information
- **Sensor Assignment**: Assign sensors to specific products for monitoring
- **Real-time Data Collection**: Record temperature, humidity, and location data from IoT devices
- **Environmental Monitoring**: Track environmental conditions throughout the supply chain journey
- **Data Validation**: Validate sensor readings within acceptable ranges (temperature: -50°C to 100°C, humidity: 0-100%)
- **Historical Analytics**: Query historical sensor data for products and locations
- **Multi-sensor Support**: Support for various sensor types (temperature, humidity, location, etc.)
- **Access Control**: Sensor owners and product manufacturers can record readings

### Smart Contract Features
- **Auto-Generated QR Codes**: Unique QR codes generated using cryptographic hashing for each product
- **QR Code Verification**: Blockchain-based verification system to prevent counterfeiting
- **Scan Tracking**: Complete audit trail of all QR code scans with timestamps and locations
- **IoT Data Integrity**: Immutable storage of sensor readings and environmental data
- **Sensor Network Management**: Register and manage IoT sensors across the supply chain
- **Real-time Monitoring**: Track products and environmental conditions in real-time
- **Immutable Records**: All supply chain, QR scan, and sensor data is permanently stored on blockchain
- **Access Control**: Role-based permissions for different participants
- **Data Integrity**: Prevents tampering with supply chain, QR code, and sensor information
- **Security Controls**: Ability to invalidate compromised QR codes and deactivate sensors

## 📋 Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Basic understanding of Clarity smart contracts
- Stacks wallet for testing
- IoT sensors compatible with the platform (temperature, humidity, location)

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

### Register IoT Sensor
```clarity
(contract-call? .traceflow register-iot-sensor "TEMP001" "temperature" "Warehouse A - Delhi")
```

### Assign Sensor to Product
```clarity
(contract-call? .traceflow assign-sensor-to-product u1 "TEMP001")
```

### Record Sensor Reading
```clarity
;; Record temperature: 25°C, humidity: 65%, location: "In Transit - Mumbai"
(contract-call? .traceflow record-sensor-reading "TEMP001" u1 25 u65 "In Transit - Mumbai")
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

### Query Functions
```clarity
;; Get product information
(contract-call? .traceflow get-product u1)

;; Get QR code information
(contract-call? .traceflow get-qr-code-info 0x1234567890abcdef...)

;; Get sensor information
(contract-call? .traceflow get-iot-sensor "TEMP001")

;; Get sensor reading
(contract-call? .traceflow get-sensor-reading u1)

;; Get product by QR code
(contract-call? .traceflow get-product-by-qr 0x1234567890abcdef...)

;; Get sensor assignment
(contract-call? .traceflow get-product-sensor-assignment u1 "TEMP001")
```

## 🏗️ Contract Architecture

### Data Structures
- **Products**: Store product information including manufacturer, name, batch number, and QR code hash
- **QR Code Registry**: Maps QR code hashes to product IDs with scan tracking and validity status
- **QR Scan History**: Complete audit trail of all QR code scans with scanner, timestamp, and location
- **IoT Sensors**: Registry of IoT sensors with type, owner, location, and status
- **Sensor Readings**: Historical record of all sensor data with environmental conditions
- **Product Sensor Assignments**: Links between products and their monitoring sensors
- **Supply Chain Stages**: Track each stage with handler, location, timestamp, and data
- **Authorized Handlers**: Manage authorized supply chain participants
- **Product Stage Count**: Track number of stages per product

### Key Functions
- `register-product`: Register new products with auto-generated QR codes
- `register-iot-sensor`: Register IoT sensors for environmental monitoring
- `assign-sensor-to-product`: Link sensors to specific products
- `record-sensor-reading`: Record temperature, humidity, and location data
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
- `get-iot-sensor`: Get IoT sensor information
- `get-sensor-reading`: Get sensor reading data
- `get-product-sensor-assignment`: Get sensor assignment details

## 🌡️ IoT Integration Details

### Supported Sensor Types
- **Temperature Sensors**: Monitor ambient temperature (-50°C to 100°C range)
- **Humidity Sensors**: Track relative humidity (0-100% range)
- **Location Sensors**: GPS/location tracking for products in transit
- **Multi-parameter Sensors**: Devices that can monitor multiple environmental factors

### Environmental Monitoring Benefits
- **Cold Chain Management**: Ensure temperature-sensitive products maintain proper conditions
- **Quality Assurance**: Track environmental factors that affect product quality
- **Compliance Tracking**: Meet regulatory requirements for environmental conditions
- **Real-time Alerts**: Monitor conditions that could damage products during transport
- **Historical Analytics**: Analyze environmental trends and optimize supply chain conditions

### IoT Data Validation
- Temperature readings must be within -50°C to 100°C range
- Humidity readings must be within 0-100% range
- Location data is validated for proper format and length
- Only authorized sensor owners or product manufacturers can record readings
- All sensor data is timestamped with blockchain block height

## 🔐 Security Features

- **QR Code Security**: Cryptographically generated QR codes prevent counterfeiting
- **Scan Auditing**: Complete audit trail of all QR code scanning activity
- **IoT Data Integrity**: Immutable storage of sensor readings prevents data tampering
- **Sensor Authentication**: Only registered sensors can submit readings
- **Access Control**: Only authorized handlers can add stages and record sensor data
- **Owner Privileges**: Contract owner can verify stages, authorize handlers, and invalidate QR codes
- **Input Validation**: Comprehensive input validation prevents invalid data
- **Immutable Records**: Blockchain ensures data cannot be tampered with
- **Anti-Counterfeiting**: QR code verification system prevents fake products
- **Environmental Security**: Track environmental tampering or exposure incidents

## 🧪 Testing

Run the test suite:
```bash
clarinet test
```

The test suite covers:
- Product registration with QR code generation
- QR code scanning and verification
- QR code invalidation and security controls
- IoT sensor registration and management
- Sensor assignment to products
- Sensor reading recording and validation
- Environmental data integrity checks
- Handler authorization
- Supply chain stage addition
- Access control verification
- Data integrity checks
- Anti-counterfeiting measures

## 🔄 IoT Integration Workflow

1. **Sensor Setup**: Register IoT sensors with unique IDs and location information
2. **Product Assignment**: Assign sensors to products for monitoring during their journey
3. **Data Collection**: IoT sensors automatically record environmental conditions
4. **Blockchain Storage**: All sensor data is stored immutably on the blockchain
5. **Real-time Monitoring**: Track environmental conditions throughout the supply chain
6. **Analytics & Alerts**: Monitor for conditions that could affect product quality
7. **Compliance Reporting**: Generate reports for regulatory compliance

## 📊 Use Cases

### Cold Chain Management
- Monitor temperature-sensitive pharmaceuticals and vaccines
- Track frozen and refrigerated food products
- Ensure compliance with temperature requirements during shipping

### Quality Assurance
- Monitor humidity levels for moisture-sensitive products
- Track environmental conditions that affect product degradation
- Provide evidence of proper handling for insurance claims

### Supply Chain Optimization
- Identify inefficient routes or storage conditions
- Optimize packaging and transportation methods
- Reduce product loss due to environmental damage

### Regulatory Compliance
- Provide immutable records for regulatory audits
- Track compliance with environmental storage requirements
- Generate automated compliance reports

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Stacks Foundation for the blockchain infrastructure
- Clarity language for secure smart contract development
- IoT device manufacturers for sensor integration support
- Manufacturing industry partners for requirements and feedback

---

**Built with ❤️ for Supply Chain Transparency and IoT Integration**