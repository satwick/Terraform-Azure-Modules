# IoT Solution

This solution demonstrates a typical IoT architecture on Azure using Terraform modules from this repository.

## Resources Deployed

- **Azure Kubernetes Service (AKS)**: For hosting containerized IoT applications.
- **Azure SQL Server**: For structured data storage.
- **Storage Account**: For blob storage.
- **Virtual Network**: For network isolation.
- **Azure Data Explorer**: For IoT data analytics.

## Architecture

```mermaid
graph TB
    subgraph "Azure Cloud"
        VNet[Virtual Network]
        subgraph "IoT Solution"
            AKS[Azure Kubernetes Service]
            SQL[Azure SQL Database]
            Storage[Storage Account]
            Apps[IoT Applications]
            ADX[Azure Data Explorer]
        end
        
        VNet -- Contains --> AKS
        VNet -- Contains --> SQL
        VNet -- Contains --> Storage
        VNet -- Contains --> ADX
        AKS -- Hosts --> Apps
        Apps -- Persists Data --> SQL
        Apps -- Stores Blobs --> Storage
        Apps -- Streams Data --> ADX
    end
```

## Usage

1. Navigate to the directory:
   ```bash
   cd solutions/iot
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review `variables.tf` and provide necessary values.
4. Apply the configuration:
   ```bash
   terraform apply
   ```
