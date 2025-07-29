# Project Documentation

## Overview

This repository contains a highly complex dbt (data build tool) project for e-commerce analytics demonstrating enterprise-level data transformation patterns. The system transforms raw transactional data into clean, business-ready datasets using modern data engineering practices. The project includes 30+ models, comprehensive sources, extensive testing, and intentional inconsistencies in column definitions to showcase real-world data challenges.

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
- **Source Data**: 10 CSV seed files (customers, orders, products, order_items, payments, inventory, suppliers, customer_segments, marketing_campaigns, returns)
- **Staging Layer**: 10 models for data cleaning and validation with intentional column inconsistencies
- **Intermediate Layer**: 7 models for business logic and enrichment across multiple domains
- **Marts Layer**: 13 models (5 dimensions, 5 facts, 3 aggregations) for comprehensive analytics
- **Snapshots**: Slowly changing dimensions tracking
- **Macros**: 3 reusable SQL functions

## Key Components

### Core dbt Components
- **Seeds**: 10 CSV files containing comprehensive e-commerce data across multiple business domains
- **Staging Models**: 10 SQL models for data cleaning and validation with intentional column naming inconsistencies
- **Intermediate Models**: 7 SQL models for business logic and enrichment across payments, inventory, marketing, and returns
- **Marts Models**: 13 SQL models (5 dimensions, 5 facts, 3 aggregations) for comprehensive analytics
- **Snapshots**: 1 snapshot for tracking customer changes over time
- **Macros**: 3 reusable SQL functions (cents_to_dollars, safe_divide, generate_schema_name)
- **Tests**: 99 total tests (96 built-in + 7 custom singular tests) with intentional warnings
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
3. **Data Quality**: Comprehensive testing with 99 tests (96 built-in + 7 custom) including intentional inconsistency detection
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
- All 99 tests pass with 3 intentional warnings demonstrating data quality challenges and column definition inconsistencies across models