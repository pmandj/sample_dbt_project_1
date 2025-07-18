# Project Documentation

## Overview

This repository contains a comprehensive dbt (data build tool) project for e-commerce analytics. The system transforms raw transactional data into clean, business-ready datasets using modern data engineering practices. The project includes 10+ models, custom tests, macros, snapshots, and mixed documentation coverage as requested.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### dbt Project Architecture
- **Data Warehouse**: DuckDB (persistent database file)
- **Transformation Tool**: dbt (data build tool)
- **Data Layers**: 
  - **Seeds**: Raw CSV data files for sample data
  - **Staging**: Data cleaning and standardization
  - **Intermediate**: Business logic and enrichment
  - **Marts**: Final dimensional models for analytics
- **Testing**: Built-in dbt tests + custom singular tests
- **Documentation**: Auto-generated dbt docs with selective coverage

### Data Pipeline
- **Source Data**: CSV seed files (customers, orders, products, order_items)
- **Staging Layer**: 4 models for data cleaning and validation
- **Intermediate Layer**: 2 models for business logic and enrichment
- **Marts Layer**: 4 models (2 dimensions, 2 facts) for analytics
- **Snapshots**: Slowly changing dimensions tracking
- **Macros**: 3 reusable SQL functions

## Key Components

### Core dbt Components
- **Seeds**: 4 CSV files containing sample e-commerce data
- **Staging Models**: 4 SQL models for data cleaning and validation
- **Intermediate Models**: 2 SQL models for business logic and enrichment
- **Marts Models**: 4 SQL models (dimensions and facts) for analytics
- **Snapshots**: 1 snapshot for tracking customer changes over time
- **Macros**: 3 reusable SQL functions (cents_to_dollars, safe_divide, generate_schema_name)
- **Tests**: 71 total tests (68 built-in + 3 custom singular tests)
- **Analyses**: 2 SQL files for business insights and reporting

### Directory Structure
```
/
├── models/
│   ├── staging/        # Data cleaning and validation
│   ├── intermediate/   # Business logic and enrichment
│   └── marts/         # Final dimensional models
├── seeds/             # Sample CSV data files
├── tests/             # Custom data quality tests
├── macros/            # Reusable SQL functions
├── snapshots/         # Slowly changing dimensions
├── analyses/          # Business insights and reporting
├── dbt_project.yml    # Main dbt configuration
└── profiles.yml       # Database connection settings
```

## Data Flow

1. **Data Ingestion**: Sample CSV data loaded via dbt seeds into DuckDB
2. **Data Transformation**: Multi-layered transformation using dbt models
   - **Staging**: Raw data cleaning and standardization
   - **Intermediate**: Business logic application and data enrichment
   - **Marts**: Final dimensional models for analytics
3. **Data Quality**: Comprehensive testing with 71 tests (68 built-in + 3 custom)
4. **Documentation**: Auto-generated interactive documentation via dbt docs

## External Dependencies

### Third-Party Services
- **DuckDB**: Local analytical database for data storage and processing
- **dbt**: Data transformation and modeling framework

### Key Libraries
- **dbt-core**: Core dbt functionality for data transformations
- **dbt-duckdb**: DuckDB adapter for dbt integration

## Deployment Strategy

### Environment Configuration
- **Development**: Local DuckDB database with persistent file storage
- **Production**: Scalable to cloud data warehouses (Snowflake, BigQuery, Redshift)

### Build Process
- **Build Command**: `dbt deps && dbt seed && dbt run && dbt test && dbt docs generate`
- **Environment Variables**: Database connection configured in profiles.yml
- **Dependencies**: Python environment with dbt packages installed

## Development Guidelines

### Code Style
- Follow dbt best practices with layered architecture
- Use consistent naming patterns (stg_, int_, dim_, fct_ prefixes)
- Maintain clear separation between staging, intermediate, and mart layers

### Testing Strategy
- Built-in dbt tests for data quality (uniqueness, not null, referential integrity)
- Custom singular tests for complex business logic validation
- Schema tests defined in YAML files for comprehensive coverage

### Common Tasks
- **Adding new models**: Create in appropriate layer (staging/intermediate/marts)
- **Database changes**: Use `dbt run` to apply model changes
- **Test modifications**: Update schema.yml files or create custom tests

## Notes for Code Agent

- This project uses DuckDB for local development with persistent file storage
- The database file `ecommerce_analytics.duckdb` maintains state between dbt runs
- Mixed documentation approach: some models documented, others intentionally left undocumented
- All 71 tests pass with 1 intentional warning for data quality demonstration