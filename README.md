# TraceFlow 🔍📱🌡️🔐🚨

> **Transparent Supply Chain Tracking with QR Code Integration, IoT Sensor Monitoring, Multi-Signature Verification, and Product Recall System on Stacks Blockchain**

TraceFlow is a decentralized supply chain transparency solution built on the Stacks blockchain using Clarity smart contracts. It enables manufacturers, suppliers, and distributors to create immutable records of product journey from creation to consumer delivery, enhanced with integrated QR code generation, verification, real-time IoT sensor monitoring, multi-signature verification for critical supply chain stages, and a comprehensive product recall system.

## 🎯 Overview

TraceFlow addresses the critical need for supply chain transparency in manufacturing by providing:

- **Product Registration**: Manufacturers can register products with unique identifiers and auto-generated QR codes
- **QR Code Integration**: Automatic QR code generation for each product with blockchain-verified authenticity
- **QR Code Scanning**: Track product scans with location and timestamp data
- **IoT Sensor Integration**: Connect with temperature, humidity, and location sensors for real-time monitoring
- **Environmental Monitoring**: Track temperature and humidity conditions throughout the supply chain
- **Multi-Signature Verification**: Require multiple authorized parties to approve critical supply chain stages
- **Product Recall System**: Rapidly recall products with automatic batch tracking and QR invalidation
- **Distributed Trust**: Enhance security by requiring consensus from multiple stakeholders
- **Emergency Pause**: Contract owner can pause all operations during security incidents or maintenance
- **Stage Tracking**: Each supply chain stage is recorded with location, handler, and timestamp
- **Handler Authorization**: Only authorized entities can add supply chain stages
- **Verification System**: Contract owner can verify stages and invalidate QR codes for security
- **Scan History**: Complete audit trail of all QR code scans with location tracking
- **Transparency**: All data is publicly accessible and immutable

## 🚀 Features

### Product Recall System 🚨 (NEW)
- **Manufacturer-Initiated Recalls**: Only product manufacturers can initiate recalls for their products
- **Automatic QR Invalidation**: QR codes are automatically invalidated when products are recalled
- **Batch Tracking**: Track recall status by batch number with recall count
- **Severity Levels**: Categorize recalls by severity (Critical, High, Medium, Low)
- **Affected Batches**: Specify which batches are affected by the recall
- **Recall Reasons**: Document detailed reasons for each recall
- **Notification System**: Built-in notification flag for recall alerts
- **Product Deactivation**: Recalled products are automatically deactivated
- **Recall History**: Complete audit trail of all recalls with timestamps
- **Batch Recall Queries**: Check if specific batches have been recalled
- **Recall Analytics**: Track total recalls and recall frequency

### Core Functionality
- **Product Registration**: Register new products with batch numbers, manufacturing details, and auto-generated QR codes
- **QR Code Management**: Generate unique, blockchain-verified QR codes for each product
- **QR Code Scanning**: Scan products to verify authenticity and track location history
- **Supply Chain Stages**: Add stages like "Raw Material Sourcing", "Manufacturing", "Quality Control", "Shipping", "Distribution"
- **Handler Management**: Authorize trusted supply chain participants
- **Stage Verification**: Verify supply chain stages for authenticity
- **Scan Analytics**: Track QR code scan frequency and locations
- **Security Controls**: Invalidate QR codes for recalls or security incidents
- **Emergency Pause**: Temporarily halt all contract operations for maintenance or security
- **Transparency**: Query product history, QR scan data, and current status

### Multi-Signature Features 🔐
- **Critical Stage Protection**: Mark important supply chain stages as requiring multi-signature approval
- **Configurable Signers**: Define which parties must sign off on each stage
- **Signature Tracking**: Track who has signed and who hasn't for each stage
- **Automatic Finalization**: Stages automatically finalize once required signatures are collected
- **Role-Based Signing**: Associate each required signer with their role (e.g., "Quality Inspector", "Customs Officer")
- **Signature Data**: Include additional context or verification data with each signature
- **Consensus Enforcement**: Stages requiring multi-sig cannot be verified until fully signed
- **Audit Trail**: Complete history of all signatures with timestamps

### IoT Sensor Features
- **Sensor Registration**: Register IoT sensors with type, location, and ownership information
- **Real-time Data Collection**: Record temperature, humidity, and location data from IoT devices
- **Environmental Monitoring**: Track environmental conditions throughout the supply chain journey
- **Data Validation**: Validate sensor readings within acceptable ranges (temperature: -50°C to 100°C, humidity: 0-100%)
- **Historical Analytics**: Query historical sensor data for products and locations
- **Alert System**: Automatic alerts for out-of-range environmental conditions
- **Multi-sensor Support**: Support for various sensor types (temperature, humidity, location, etc.)
- **Access Control**: Only authorized sensors can submit readings

### Emergency Controls 🚨
- **Contract Pause**: Owner can immediately pause all state-changing operations
- **Maintenance Mode**: Safely perform upgrades or investigate security issues
- **Read-Only Access**: All query functions remain available during pause
- **Quick Recovery**: Single transaction to resume normal operations
- **Audit Trail**: Pause/unpause events recorded on-chain

### Smart Contract Features
- **Auto-Generated QR Codes**: Unique QR codes generated using cryptographic hashing for each product
- **QR Code Verification**: Blockchain-based verification system to prevent counterfeiting
- **Scan Tracking**: Complete audit trail of all QR code scanning activity
- **IoT Data Integrity**: Immutable storage of sensor readings and environmental data
- **Multi-Party Consensus**: Distributed approval system for critical decisions
- **Signature Management**: Track and verify multi-party signatures
- **Recall Management**: Immutable record of all product recalls with batch tracking
- **Real-time Monitoring**: Track products and environmental conditions in real-time
- **Immutable Records**: All supply chain, QR scan, sensor, recall, and signature data is permanently stored on blockchain
- **Access Control**: Role-based permissions for different participants
- **Data Integrity**: Prevents tampering with supply chain, QR code, recall, and sensor information
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

### Product Recall System (NEW) 🚨

#### Initiate a Product Recall
```clarity
;; Manufacturer recalls a product
(contract-call? .traceflow recall-product 
  u1  ;; product-id
  "Contamination detected in production batch. Potential safety hazard."  ;; reason
  "Critical"  ;; severity
  "BATCH-2024-001, BATCH-2024-002")  ;; affected-batches
```

#### Query Recall Information
```clarity
;; Get recall details
(contract-call? .traceflow get-recall-info u1)

;; Check if a batch is recalled
(contract-call? .traceflow is-batch-recalled "BATCH-2024-001")

;; Get total number of recalls
(contract-call? .traceflow get-total-recalls)

;; Check product recall status
(contract-call? .traceflow get-product u1)
;; Returns product info including is-recalled and recall-id fields
```

### Emergency Pause Controls
```clarity
;; Pause contract during security incident or maintenance
(contract-call? .traceflow pause-contract)

;; Resume normal operations
(contract-call? .traceflow unpause-contract)

;; Check pause status
(contract-call? .traceflow is-contract-paused)
```

### Register a Product (with QR Code)
```clarity
;; Returns both product-id and qr-code-hash
(contract-call? .traceflow register-product "Organic Cotton T-Shirt" "BATCH-2024-001")
```

### Add Supply Chain Stage (with Multi-Signature Requirement)
```clarity
;; Add a critical stage that requires multiple signatures
(contract-call? .traceflow add-supply-chain-stage 
  u1 
  "Quality Control Inspection" 
  "Manufacturing Facility - Delhi" 
  "Final quality inspection before shipment"
  true) ;; requires-multisig = true
```

### Add Required Signers for Multi-Sig Stage
```clarity
;; Add quality inspector as required signer
(contract-call? .traceflow add-required-signer 
  u1 
  u3 
  'ST1QUALITYINSPECTOR123 
  "Quality Inspector")

;; Add compliance officer as required signer
(contract-call? .traceflow add-required-signer 
  u1 
  u3 
  'ST1COMPLIANCEOFFICER456 
  "Compliance Officer")
```

### Sign a Multi-Signature Stage
```clarity
;; Quality inspector signs the stage
(contract-call? .traceflow sign-stage 
  u1 
  u3 
  "Quality inspection passed. All parameters within acceptable range.")

;; Compliance officer signs the stage
(contract-call? .traceflow sign-stage 
  u1 
  u3 
  "Compliance verified. All regulatory requirements met.")
```

### Verify Stage (After Multi-Sig Complete)
```clarity
;; Contract owner can verify once all required signatures are collected
(contract-call? .traceflow verify-stage u1 u3)
```

### Register IoT Sensor
```clarity
(contract-call? .traceflow authorize-sensor "TEMP001" "temperature" "Warehouse A - Delhi")
```

### Record Sensor Reading
```clarity
;; Record temperature: 25°C, humidity: 65%, location coordinates
(contract-call? .traceflow add-sensor-reading 
  u1 
  "TEMP001" 
  2500 
  u65 
  2893000 
  7717000 
  "Normal conditions")
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

### Query Functions
```clarity
;; Check if contract is paused
(contract-call? .traceflow is-contract-paused)

;; Get product information (includes recall status)
(contract-call? .traceflow get-product u1)

;; Get recall information
(contract-call? .traceflow get-recall-info u1)

;; Check if batch is recalled
(contract-call? .traceflow is-batch-recalled "BATCH-2024-001")

;; Get total recalls
(contract-call? .traceflow get-total-recalls)

;; Get supply chain stage with multi-sig info
(contract-call? .traceflow get-supply-chain-stage u1 u3)

;; Get stage signature
(contract-call? .traceflow get-stage-signature u1 u3 'ST1QUALITYINSPECTOR123)

;; Check if required signer
(contract-call? .traceflow get-required-signer u1 u3 'ST1QUALITYINSPECTOR123)

;; Check if stage is finalized
(contract-call? .traceflow is-stage-finalized u1 u3)

;; Get QR code information
(contract-call? .traceflow get-qr-code-info 0x1234567890abcdef...)

;; Get sensor information
(contract-call? .traceflow get-sensor-info "TEMP001")

;; Get sensor reading
(contract-call? .traceflow get-sensor-reading u1 u1)

;; Get product by QR code
(contract-call? .traceflow get-product-by-qr 0x1234567890abcdef...)
```

## 🏗️ Contract Architecture

### Data Structures
- **Products**: Store product information including manufacturer, name, batch number, QR code hash, and recall status
- **Product Recalls**: Track recall details including reason, severity, affected batches, and timestamps
- **Batch Recalls**: Monitor recall status and count by batch number
- **QR Code Registry**: Maps QR code hashes to product IDs with scan tracking and validity status
- **QR Scan History**: Complete audit trail of all QR code scans with scanner, timestamp, and location
- **IoT Sensors**: Registry of IoT sensors with type, owner, location, and status
- **Sensor Readings**: Historical record of all sensor data with environmental conditions
- **Supply Chain Stages**: Track each stage with handler, location, timestamp, multi-sig requirements
- **Stage Signatures**: Store all signatures for multi-signature stages with signer and timestamp
- **Required Signers**: Define which principals must sign each multi-sig stage
- **Authorized Handlers**: Manage authorized supply chain participants
- **Product Stage Count**: Track number of stages per product
- **Contract Pause State**: Boolean flag for emergency pause functionality

### Key Functions

#### Product Recall Functions 🚨 (NEW)
- `recall-product`: Initiate product recall with reason, severity, and affected batches
- `get-recall-info`: Retrieve detailed recall information by recall ID
- `is-batch-recalled`: Check if a specific batch has been recalled
- `get-total-recalls`: Get the total number of recalls in the system

#### Emergency Control Functions 🚨
- `pause-contract`: Immediately halt all state-changing operations
- `unpause-contract`: Resume normal contract operations
- `is-contract-paused`: Query current pause status

#### Product & QR Code Functions
- `register-product`: Register new products with auto-generated QR codes
- `scan-qr-code`: Scan QR codes and record scan activity with location
- `verify-qr-code`: Verify QR code authenticity against product ID
- `invalidate-qr-code`: Invalidate QR codes for security or recalls
- `get-product`: Retrieve product information (includes recall status)
- `get-qr-code-info`: Get QR code details and scan statistics
- `get-product-by-qr`: Retrieve product information using QR code
- `get-qr-scan-history`: Get detailed scan history for QR codes

#### Multi-Signature Functions 🔐
- `add-supply-chain-stage`: Add new supply chain stages (with optional multi-sig requirement)
- `add-required-signer`: Define who must sign a multi-signature stage
- `sign-stage`: Sign a multi-signature stage with verification data
- `get-stage-signature`: Retrieve signature details for a specific signer
- `get-required-signer`: Check if a principal is a required signer
- `is-stage-finalized`: Check if a stage has collected all required signatures

#### IoT Sensor Functions
- `authorize-sensor`: Register IoT sensors for environmental monitoring
- `add-sensor-reading`: Record temperature, humidity, and location data
- `get-sensor-info`: Get IoT sensor information
- `get-sensor-reading`: Get sensor reading data

#### Handler & Verification Functions
- `authorize-handler`: Authorize supply chain participants
- `verify-stage`: Verify stages for authenticity (requires multi-sig completion)
- `get-handler-info`: Get handler information
- `get-stage-count`: Get number of stages for a product
- `get-reading-count`: Get number of sensor readings for a product

## 🚨 Product Recall Workflow

### Recall Initiation
1. **Detection**: Manufacturer identifies issue (contamination, defect, safety concern)
2. **Decision**: Determine severity level and affected batches
3. **Execution**: Call `recall-product` with reason, severity, and batch information
4. **Automatic Actions**:
   - Product marked as recalled
   - QR code automatically invalidated
   - Product deactivated
   - Batch tracking updated
   - Recall notification flag set

### Recall Verification
- **Consumers**: Scan QR codes to check recall status
- **Retailers**: Query batch numbers to identify recalled products
- **Regulators**: Access complete recall history and audit trail
- **Supply Chain**: Track recall propagation through the chain

### Benefits
- **Rapid Response**: Instant recall notification across the entire supply chain
- **Traceability**: Track exactly which batches are affected
- **Consumer Safety**: Prevent recalled products from reaching consumers
- **Regulatory Compliance**: Maintain complete audit trail for authorities
- **Brand Protection**: Quick action demonstrates commitment to safety

## 🚨 Emergency Pause Use Cases

### Security Incident Response
When a vulnerability is discovered or suspicious activity is detected:
- Immediately pause all operations to prevent exploitation
- Investigate the issue safely while preserving data integrity
- Resume operations once the issue is resolved

### Smart Contract Upgrades
During planned maintenance or upgrades:
- Pause contract to prevent state changes during migration
- Complete upgrade process safely
- Unpause to resume with new features

### Regulatory Compliance
When regulatory requirements necessitate temporary suspension:
- Pause operations to comply with legal requirements
- Maintain read-only access for auditing
- Resume once compliance issues are addressed

### Network Congestion
During extreme network conditions:
- Temporarily pause to prevent failed transactions
- Wait for network stability
- Resume normal operations when conditions improve

## 🔐 Multi-Signature Use Cases

### Quality Control Checkpoint
Require sign-off from multiple quality inspectors before a product moves to the next stage:
- Quality Inspector A signs after visual inspection
- Quality Inspector B signs after testing measurements
- Stage finalizes automatically when both signatures collected

### Customs Clearance
International shipments requiring approval from multiple authorities:
- Customs Officer verifies documentation
- Safety Inspector confirms product compliance
- Both signatures required before shipment proceeds

### High-Value Product Transfer
Expensive items requiring dual authorization:
- Warehouse Manager signs for physical transfer
- Finance Officer signs for inventory value transfer
- Both parties must agree before transaction completes

### Pharmaceutical Cold Chain
Critical temperature-sensitive medications:
- Temperature Monitor confirms acceptable conditions
- Pharmacist verifies product integrity
- Both signatures required for each transfer point

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

## 🔐 Security Features

- **Product Recall System**: Rapid response to safety issues with automatic QR invalidation
- **Batch Tracking**: Monitor recall status by batch number
- **Emergency Pause**: Halt all operations immediately during security incidents
- **QR Code Security**: Cryptographically generated QR codes prevent counterfeiting
- **Scan Auditing**: Complete audit trail of all QR code scanning activity
- **Multi-Signature Consensus**: Distributed approval prevents single-party manipulation
- **Signature Verification**: Blockchain-verified signatures ensure authenticity
- **IoT Data Integrity**: Immutable storage of sensor readings prevents data tampering
- **Sensor Authentication**: Only registered sensors can submit readings
- **Access Control**: Only authorized handlers and required signers can add stages and signatures
- **Manufacturer Authorization**: Only product manufacturers can initiate recalls
- **Owner Privileges**: Contract owner can verify stages, authorize handlers, and invalidate QR codes
- **Input Validation**: Comprehensive input validation prevents invalid data
- **Immutable Records**: Blockchain ensures data cannot be tampered with
- **Anti-Counterfeiting**: QR code verification system prevents fake products
- **Consensus Enforcement**: Multi-sig stages cannot be verified until fully signed

## 🧪 Testing

Run the test suite:
```bash
clarinet test
```

The test suite covers:
- Product recall initiation and validation
- Batch recall tracking
- Recall information queries
- Emergency pause and unpause functionality
- Pause enforcement on state-changing operations
- Product registration with QR code generation
- QR code scanning and verification
- QR code invalidation and security controls
- Multi-signature stage creation and signing
- Required signer management
- Signature validation and finalization
- Consensus enforcement
- IoT sensor registration and management
- Sensor reading recording and validation
- Environmental data integrity checks
- Handler authorization
- Supply chain stage addition
- Access control verification
- Data integrity checks
- Anti-counterfeiting measures

## 🔄 Multi-Signature Workflow

1. **Stage Creation**: Handler creates a new supply chain stage with multi-sig requirement enabled
2. **Signer Definition**: Stage creator adds required signers with their roles
3. **Signature Collection**: Each required signer reviews and signs the stage
4. **Automatic Finalization**: Stage automatically finalizes when signature threshold (2) is reached
5. **Verification**: Contract owner can verify the finalized stage
6. **Audit Trail**: Complete history of all signatures is preserved on-chain

## 📊 Use Cases

### Pharmaceutical Supply Chain
- Multi-sig for quality control: Pharmacist + Lab Technician
- Temperature monitoring throughout cold chain
- QR code verification at each pharmacy
- **Rapid recall for contaminated batches**
- Emergency pause during recall situations
- Complete audit trail for regulatory compliance

### Luxury Goods Authentication
- Multi-sig for authenticity: Brand Representative + Independent Appraiser
- QR codes prevent counterfeiting
- Track location throughout supply chain
- **Product recall for defective items**
- Pause during security investigations
- Verify authenticity at point of sale

### Food Safety & Traceability
- Multi-sig for safety inspections: Health Inspector + Quality Manager
- Temperature and humidity monitoring during transport
- Track farm-to-table journey
- **Instant recall for contaminated products**
- Emergency pause during contamination events
- Rapid recall capability with QR code invalidation

### Aerospace Parts Manufacturing
- Multi-sig for critical inspections: Engineer + Safety Officer
- Environmental monitoring during production
- Complete documentation for each component
- **Critical part recall system**
- Pause during quality incidents
- Regulatory compliance tracking

### Consumer Electronics
- Multi-sig for quality assurance
- **Battery recall management**
- Track warranty and service history
- Prevent counterfeit components
- Safety compliance tracking

## 📝 Error Codes

- `ERR-OWNER-ONLY (u100)`: Only contract owner can perform this action
- `ERR-NOT-FOUND (u101)`: Requested resource not found
- `ERR-ALREADY-EXISTS (u102)`: Resource already exists
- `ERR-UNAUTHORIZED (u103)`: Caller not authorized for this action
- `ERR-INVALID-STAGE (u104)`: Stage operation invalid
- `ERR-INVALID-INPUT (u105)`: Input parameters invalid
- `ERR-SENSOR-NOT-AUTHORIZED (u106)`: Sensor not authorized
- `ERR-INVALID-SENSOR-DATA (u107)`: Sensor data out of range
- `ERR-QR-CODE-INVALID (u108)`: QR code invalidated
- `ERR-QR-CODE-EXPIRED (u109)`: QR code expired
- `ERR-ALREADY-SIGNED (u110)`: Signer already signed this stage
- `ERR-INSUFFICIENT-SIGNATURES (u111)`: Not enough signatures collected
- `ERR-NOT-REQUIRED-SIGNER (u112)`: Caller not a required signer
- `ERR-STAGE-NOT-PENDING (u113)`: Stage already finalized
- `ERR-CONTRACT-PAUSED (u114)`: Contract operations paused
- `ERR-ALREADY-RECALLED (u115)`: Product already recalled (NEW)
- `ERR-NOT-MANUFACTURER (u116)`: Only manufacturer can recall product (NEW)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [Stacks Blockchain](https://www.stacks.co/)
- [Clarity Documentation](https://docs.stacks.co/clarity/)
- [Clarinet Documentation](https://docs.hiro.so/clarinet/)

---

Built with ❤️ on Stacks Blockchain