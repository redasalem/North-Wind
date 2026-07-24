# 🛍️ productive-store

[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-blue.svg?logo=typescript)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-19.0-61DAFB.svg?logo=react)](https://react.dev/)
[![Express.js](https://img.shields.io/badge/Express-5.2-000000.svg?logo=express)](https://expressjs.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Drizzle_ORM-4169E1.svg?logo=postgresql)](https://orm.drizzle.team/)
[![Clerk](https://img.shields.io/badge/Auth-Clerk-6C47FF.svg?logo=clerk)](https://clerk.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg?logo=docker)](https://www.docker.com/)

A modern, full-stack E-Commerce Monolith built with **React (Vite)**, **Express (Node.js)**, **PostgreSQL (Drizzle ORM)**, and **Clerk Authentication**. The repository is architected for seamless single-domain deployment using a multi-stage **Docker** build.

---

## 📌 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Architecture](#-project-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Configuration](#environment-configuration)
  - [Database Setup & Migrations](#database-setup--migrations)
  - [Running Locally](#running-locally)
- [Single-Domain & Docker Deployment](#-single-domain--docker-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

- **🔐 Robust Authentication & Role Management**
  - Instant user onboarding & secure session management via **Clerk**.
  - Webhook synchronization between Clerk and local PostgreSQL database.
  - Role-based access control (`customer`, `support`, `admin`).

- **📦 Product Catalog & Order System**
  - High-performance PostgreSQL database powered by **Drizzle ORM**.
  - Product management with ImageKit integration for asset handling.
  - Order tracking and checkout session pipeline.

- **💳 Payments & Billing**
  - Integrated with **Polar.sh** for checkout sessions and payment processing.

- **💬 Real-Time Chat & Support**
  - Powered by **Stream Chat SDK** for seamless customer care.

- **📊 Error Tracking & Observability**
  - Integrated **Sentry** SDK for backend crash reporting and performance profiling.

- **🚀 Single-Domain Monolith Deployment**
  - Multi-stage Docker build bundles the Vite frontend directly into Express static file hosting (`public/`).
  - Solves CORS issues and simplifies hosting under one domain.

---

## 🛠️ Tech Stack

### Frontend
- **Framework:** React 19 + Vite 8
- **Authentication UI:** `@clerk/react`
- **Linting & Code Quality:** ESLint

### Backend
- **Runtime & Framework:** Node.js (v22) + Express.js 5
- **Language:** TypeScript 5
- **ORM & Database:** Drizzle ORM + PostgreSQL (`pg` driver)
- **Webhooks & Auth:** `@clerk/express`, `@clerk/backend`, `standardwebhooks`
- **Integrations:** ImageKit Node SDK, Stream Chat SDK, Polar.sh API, Sentry

---

## 🏗️ Project Architecture

```
                       +-----------------------------------+
                       |        Single Host / Domain       |
                       |                                   |
                       |   +---------------------------+   |
                       |   |    Express.js (Port 3001) |   |
                       |   +-------------+-------------+   |
                       |                 |                 |
                       |  /api &         | Static Files    |
                       |  /webhooks      | (from /public)  |
                       |                 v                 |
                       |            React SPA              |
                       +--------+-----------------+--------+
                                |                 |
                                v                 v
                         PostgreSQL Database    External Services
                         (Neon / Supabase)      (Clerk, Polar, Stream)
```

---

## 📂 Project Structure

```
northwind-store/
├── Dockerfile                  # Multi-stage production build script
├── .dockerignore               # Docker build exclusions
├── backend/                    # Express Backend
│   ├── src/
│   │   ├── db/                 # Drizzle database connection & schemas
│   │   │   ├── index.ts
│   │   │   └── schema.ts
│   │   ├── lib/                # Environment validation (Zod) & Role parsers
│   │   │   ├── env.ts
│   │   │   └── roles.ts
│   │   ├── webhooks/           # Clerk webhook handler
│   │   │   └── clerk.ts
│   │   └── index.ts            # Server entry point & static file serving
│   ├── drizzle.config.ts       # Drizzle Kit configuration
│   ├── package.json
│   └── tsconfig.json
└── frontend/                   # Vite + React Frontend
    ├── src/
    │   ├── App.jsx             # Main application shell & Clerk auth components
    │   ├── main.jsx
    │   └── index.css
    ├── index.html
    ├── package.json
    └── vite.config.js
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed locally:
- [Node.js](https://nodejs.org/) (v20 or v22 recommended)
- [pnpm](https://pnpm.io/) or `npm`
- [PostgreSQL](https://www.postgresql.org/) database instance (or [Neon](https://neon.tech) / [Supabase](https://supabase.com))

---

### Installation

Clone the repository and install dependencies for both `backend` and `frontend`:

```bash
git clone https://github.com/redasalem/North-Wind.git
cd North-Wind

# Install Backend dependencies
cd backend
pnpm install

# Install Frontend dependencies
cd ../frontend
pnpm install
```

---

### Environment Configuration

Create a `.env` file inside the `backend/` directory based on the following variables:

```env
# Backend Environment
NODE_ENV=development
PORT=3001
DATABASE_URL=postgresql://user:password@localhost:5432/northwind_db

# Clerk Authentication Keys
CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
CLERK_WEBHOOK_SECRET=whsec_...

# Frontend URL
FRONTEND_URL=http://localhost:5173

# Polar Payments
POLAR_ACCESS_TOKEN=polar_at_...
POLAR_WEBHOOK_SECRET=polar_whsec_...
POLAR_API_BASE=https://api.polar.sh
POLAR_CHECKOUT_PRODUCT_ID=prod_...

# Stream Chat
STREAM_API_KEY=your_stream_key
STREAM_API_SECRET=your_stream_secret

# ImageKit
IMAGEKIT_PUBLIC_KEY=public_...
IMAGEKIT_PRIVATE_KEY=private_...
IMAGEKIT_URL_ENDPOINT=https://ik.imagekit.io/your_id

# Sentry Observability (Optional)
SENTRY_DSN=https://...
```

For the **Frontend**, ensure your Vite environment variables match your Clerk application:
```env
VITE_CLERK_PUBLISHABLE_KEY=pk_test_...
VITE_API_URL=http://localhost:3001
```

---

### Database Setup & Migrations

To apply database schemas to your PostgreSQL instance using **Drizzle Kit**:

```bash
cd backend
pnpm run db:push
```

---

### Running Locally

Run backend and frontend servers in development mode:

1. **Backend Server:**
   ```bash
   cd backend
   pnpm run dev
   ```

2. **Frontend Dev Server:**
   ```bash
   cd frontend
   pnpm run dev
   ```

---

## 🐳 Single-Domain & Docker Deployment

The project includes a production-grade [Dockerfile](file:///e:/coding/pren-projects/northwind-store/Dockerfile) that bundles both the React frontend and Express API into a single container image.

### Building & Running with Docker

1. **Build the Image:**
   ```bash
   docker build -t northwind-store \
     --build-arg VITE_CLERK_PUBLISHABLE_KEY="your_clerk_pub_key" \
     .
   ```

2. **Run the Container:**
   ```bash
   docker run -d -p 3001:3001 --env-file backend/.env northwind-store
   ```

3. Open `http://localhost:3001` in your browser. The Express server will handle both API requests and serve the React Single Page Application (SPA).

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check the [Issues page](https://github.com/redasalem/North-Wind/issues).

---

## 📄 License

This project is licensed under the [ISC License](LICENSE).
