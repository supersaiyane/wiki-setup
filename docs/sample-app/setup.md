---
sidebar_position: 3
---

# Setup Guide

How to get this app running locally.

## Prerequisites

- Node.js v18+
- Docker
- PostgreSQL

## Installation

```bash
git clone https://github.com/username/repo.git
cd repo
npm install
```

## Environment Variables

Create a `.env` file:

```
DATABASE_URL=postgres://localhost:5432/myapp
API_KEY=your-api-key-here
PORT=3000
```

## Run

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).
