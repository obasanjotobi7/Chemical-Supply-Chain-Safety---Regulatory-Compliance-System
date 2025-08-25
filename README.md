# Chemical Supply Chain Safety & Regulatory Compliance System

A comprehensive blockchain-based system for managing chemical supply chain safety, regulatory compliance, and worker certification using Clarity smart contracts.

## System Overview

This system provides end-to-end tracking and compliance management for chemical supply chains, ensuring safety protocols, regulatory adherence, and proper documentation throughout the entire lifecycle.

## Core Components

### 1. Chemical Registry Contract (`chemical-registry.clar`)
- Chemical classification and hazard identification
- GHS (Globally Harmonized System) compliance
- Safety data sheet (SDS) management
- Chemical property tracking

### 2. Transportation Safety Contract (`transportation-safety.clar`)
- Transportation permit management
- Route safety verification
- Emergency response protocols
- Carrier certification tracking

### 3. Storage Facility Contract (`storage-facility.clar`)
- Facility registration and monitoring
- Storage condition tracking
- Inspection scheduling and results
- Capacity and compatibility management

### 4. Regulatory Compliance Contract (`regulatory-compliance.clar`)
- Compliance reporting automation
- Regulatory requirement tracking
- Audit trail maintenance
- Violation management

### 5. Worker Safety Contract (`worker-safety.clar`)
- Training certification management
- Safety protocol compliance
- Incident reporting and tracking
- Competency verification

## Key Features

- **Immutable Records**: All safety and compliance data stored on blockchain
- **Real-time Monitoring**: Continuous tracking of chemical movements and storage
- **Automated Compliance**: Smart contract-based regulatory requirement enforcement
- **Emergency Response**: Rapid access to safety information during incidents
- **Audit Trail**: Complete transparency for regulatory inspections

## Data Types

### Chemical Classification
- Chemical ID and name
- CAS number and molecular formula
- Hazard classes and categories
- Physical and chemical properties
- Storage and handling requirements

### Transportation Records
- Shipment tracking numbers
- Origin and destination facilities
- Transportation routes and methods
- Emergency contact information
- Carrier certifications

### Storage Monitoring
- Facility identification and location
- Storage conditions (temperature, humidity, pressure)
- Inventory levels and turnover
- Inspection schedules and results
- Incident reports

### Compliance Tracking
- Regulatory framework adherence
- Reporting deadlines and submissions
- Violation records and remediation
- Certification status

### Worker Certification
- Training completion records
- Competency assessments
- Safety protocol acknowledgments
- Incident involvement history

## Security Features

- Role-based access control
- Multi-signature requirements for critical operations
- Encrypted sensitive data storage
- Audit logging for all transactions

## Compliance Standards

- OSHA Hazard Communication Standard
- DOT Hazardous Materials Regulations
- EPA Chemical Safety and Security
- GHS Classification and Labeling
- ISO 45001 Occupational Health and Safety

## Usage

1. **Chemical Registration**: Register new chemicals with complete safety profiles
2. **Transportation Planning**: Create and verify transportation permits
3. **Storage Management**: Monitor facility conditions and schedule inspections
4. **Compliance Reporting**: Generate automated regulatory reports
5. **Worker Training**: Track and verify safety training completion

## Testing

The system includes comprehensive test coverage using Vitest:
- Unit tests for each contract function
- Integration tests for cross-contract workflows
- Compliance scenario testing
- Emergency response simulation

## Deployment

Configure your environment using the provided `Clarinet.toml` and deploy contracts in the following order:
1. Chemical Registry
2. Storage Facility
3. Transportation Safety
4. Worker Safety
5. Regulatory Compliance

## Contributing

Please refer to `PR-DETAILS.md` for contribution guidelines and pull request requirements.
