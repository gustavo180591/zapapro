# ZapaPro - E-commerce Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/zapapro/pulls)

ZapaPro is a modern e-commerce platform for footwear, built with a focus on performance, scalability, and developer experience.

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or later)
- [pnpm](https://pnpm.io/) (v8 or later)
- [Docker](https://www.docker.com/) and Docker Compose
- [Git](https://git-scm.com/)

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/zapapro.git
   cd zapapro
   ```

2. **Set up environment variables**
   ```bash
   # Copy example environment files
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
   
   # Edit the .env files with your configuration
   # You can use your preferred editor to modify the values
   ```

3. **Start development services**
   ```bash
   # Start PostgreSQL and Redis using Docker Compose
   docker compose up -d
   
   # Install dependencies
   pnpm install
   
   # Start backend and frontend in development mode
   pnpm dev
   ```

4. **Access the applications**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3001
   - API Documentation: http://localhost:3001/docs
   - Database (PostgreSQL):
     - Host: localhost
     - Port: 5432
     - Database: zapapro
     - Username: zapapro
     - Password: zapapro
   - Redis: localhost:6379

### Running Tests

```bash
# Run backend tests
cd backend
pnpm test

# Run frontend tests
cd ../frontend
pnpm test

# Run end-to-end tests
pnpm test:e2e
```

### Building for Production

```bash
# Build both frontend and backend
pnpm build

# Start production services
docker compose -f docker-compose.prod.yml up -d
```

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/zapapro/pulls)

ZapaPro is a modern e-commerce platform for footwear, built with a focus on performance, scalability, and developer experience.

## 🚀 Tech Stack

### Frontend
- **Framework**: SvelteKit
- **Styling**: Tailwind CSS
- **State Management**: Svelte Stores
- **Testing**: Playwright (E2E)

### Backend
- **Framework**: NestJS
- **Database**: PostgreSQL with Prisma ORM
- **Cache/Queue**: Redis & Amazon SQS
- **Authentication**: JWT + OAuth2 PKCE
- **API Documentation**: OpenAPI/Swagger
- **Testing**: Jest + Supertest

### Infrastructure
- **Containerization**: Docker
- **Orchestration**: AWS ECS Fargate
- **CI/CD**: GitHub Actions
- **IaC**: Terraform
- **Monitoring**: Amazon CloudWatch
- **CDN**: CloudFront + S3

## 🛠️ Development Setup

### Prerequisites

- Node.js 18+
- pnpm 8+
- Docker & Docker Compose
- PostgreSQL 14+
- Redis 6+

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/zapapro.git
   cd zapapro
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Set up environment variables**
   ```bash
   cp backend/.env.example backend/.env
   cp frontend/.env.example frontend/.env
   # Edit the .env files with your configuration
   ```

4. **Start development services**
   ```bash
   # Start database and cache
   docker-compose up -d postgres redis
   
   # Run database migrations
   cd backend
   pnpm prisma:migrate
   pnpm prisma:seed
   
   # Start backend and frontend in development mode
   pnpm dev
   ```

5. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3001
   - API Documentation: http://localhost:3001/docs

## 📦 Project Structure

```
zapapro/
├── backend/               # NestJS backend
│   ├── prisma/           # Database schema and migrations
│   ├── src/              # Source code
│   │   ├── modules/      # Feature modules
│   │   ├── common/       # Shared code
│   │   └── config/       # Configuration
│   └── test/             # Tests
├── frontend/             # SvelteKit frontend
│   ├── src/
│   │   ├── lib/         # Shared components and utilities
│   │   └── routes/      # Application routes
├── infra/                # Infrastructure as Code
│   ├── terraform/       # Terraform configurations
│   └── docker/          # Docker configurations
└── docs/                # Documentation
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
pnpm test           # Unit tests
pnpm test:e2e       # E2E tests
pnpm test:cov       # Test coverage
```

### Frontend Tests
```bash
cd frontend
pnpm test           # Unit tests
pnpm test:e2e       # E2E tests
```

## 🚀 Deployment

### Prerequisites
- AWS Account
- Terraform 1.0+
- AWS CLI configured

### Deployment Steps
1. **Build and push Docker images**
   ```bash
   # Build and push backend
   cd backend
   pnpm build
   docker build -t your-ecr-repo/backend:latest .
   
   # Build and push frontend
   cd ../frontend
   pnpm build
   docker build -t your-ecr-repo/frontend:latest .
   ```

2. **Deploy infrastructure**
   ```bash
   cd infra/terraform
   terraform init
   terraform plan
   terraform apply
   ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) to get started.

## 📧 Contact

For any questions or feedback, please open an issue or contact the maintainers.
