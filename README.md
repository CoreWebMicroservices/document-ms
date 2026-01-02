# Document Management Service

> **Part of [Core Microservices Project](https://github.com/CoreWebMicroservices/corems-project)** - Enterprise-grade microservices toolkit for rapid application development

File upload, storage, and access control microservice for CoreMS.

## Features

- File upload (multipart/base64)
- Document metadata management
- Access control and permissions
- Public/private document sharing
- S3-compatible storage (MinIO)

## Quick Start
```bash
# Clone the main project
git clone https://github.com/CoreWebMicroservices/corems-project.git
cd corems-project

# Build and start document service
./setup.sh build document-ms
./setup.sh start document-ms

# Or start entire stack
./setup.sh start-all
```

### API Endpoints
- **Base URL**: `http://localhost:3002`
- **Health**: `GET /actuator/health`
- **Upload**: `POST /api/documents/upload`
- **Download**: `GET /api/documents/{uuid}/download`
- **List**: `GET /api/documents`

## Environment Variables

Copy `.env-example` to `.env` and configure:
```bash
DATABASE_URL=jdbc:postgresql://localhost:5432/corems
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET_NAME=documents
```

## Database Schema

- `document_ms` schema with tables:
  - `document` - Document metadata
  - `document_tags` - Document tagging
  - `document_access_token` - Temporary access tokens

## Architecture

```
document-ms/
├── document-api/      # OpenAPI spec + generated models
├── document-client/   # API client for other services
├── document-service/  # Main application
└── migrations/        # Database migrations
```