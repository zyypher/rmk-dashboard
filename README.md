# 🧠 RMK Experts — Training Management Dashboard

Welcome to the **RMK Experts Training Management System** — an advanced web-based platform designed to streamline the entire training lifecycle for educational and corporate training institutions.  

Built using **Next.js 14**, **TailwindCSS**, **Prisma**, and **PostgreSQL**, it features an intelligent and modern admin dashboard for managing courses, trainers, bookings, clients, and performance analytics.

---

## 📊 Overview

![RMK Experts Dashboard Banner](./banner.png)

This platform enables administrators and training coordinators to manage operations efficiently, from course scheduling and trainer management to real-time booking analytics and automated report generation.

### 🔹 Core Functionalities
- 📅 **Training Management** — Courses, categories, trainers, trainer leaves, and calendars.  
- 🏢 **Management Modules** — Clients, locations, and delegates.  
- 🧾 **Bookings & Reports** — Bookings overview, analytics charts, and report exports.  
- 🧑‍🏫 **Trainer & Room Management** — Scheduling, leaves, and resource allocation.  
- 🌐 **System Administration** — User roles, permissions, settings, and languages.  
- 📈 **Dashboard Analytics** — Visual performance tracking via **ApexCharts** and **Recharts**.

---

## ⚙️ Tech Stack

| Category | Technologies Used |
|-----------|-------------------|
| **Frontend** | Next.js 14, React 18, TailwindCSS, TypeScript, Radix UI, React Hook Form |
| **Backend** | Prisma ORM, Next.js API Routes, Node.js |
| **Database** | PostgreSQL |
| **Authentication** | JSON Web Tokens (JWT) |
| **Storage** | AWS S3 |
| **Email Services** | SendGrid |
| **Visualization** | ApexCharts, Recharts |
| **Utilities** | Date-fns, Lodash, ExcelJS, PDF-Lib, React-Quill, FullCalendar |

---

## 🛠️ Getting Started

Clone the repository and install dependencies:

```bash
git clone https://github.com/therealvishnuvinayan/rmk-dashboard.git
cd rmk-dashboard
npm install
```

Create a `.env` file in the root directory using the provided environment variables:

```bash
DATABASE_URL=
JWT_SECRET=
NEXT_PUBLIC_API_BASE_URL=
NEXT_PUBLIC_AWS_REGION=
NEXT_PUBLIC_AWS_ACCESS_KEY_ID=
NEXT_PUBLIC_AWS_SECRET_ACCESS_KEY=
NEXT_PUBLIC_AWS_BUCKET_NAME=
SENDGRID_API_KEY=
SENDGRID_FROM_EMAIL=
```

Push your Prisma schema and start the development server:

```bash
npm run db:push
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the app.

---

## 📁 Folder Structure

```
.
├── app/                # Next.js App Router pages & layouts
├── components/         # Shared UI and logic components
├── prisma/             # Database schema and migrations
├── public/             # Static assets and uploaded media
├── styles/             # Tailwind and global styles
└── package.json
```

---

## 🧩 Key Highlights

- 🧾 Automated report generation with ExcelJS and jsPDF  
- 📊 Real-time charting via ApexCharts and Recharts  
- 📅 Interactive FullCalendar integration for scheduling  
- ☁️ AWS S3 file storage for documents and certificates  
- ✉️ Email automation powered by SendGrid  
- ⚡ Optimized Next.js API routes and Prisma transactions  
- 🔐 Secure JWT-based authentication

---

## 🚀 Deployment

The project is configured for deployment on **Vercel**, with database hosting on **Vercel Postgres** or **AWS RDS**.

```bash
npm run build
npm start
```

---

## 👨‍💻 About

Developed by **Vishnu Vinayan** — Senior Full Stack Developer passionate about scalable systems, UI/UX precision, and intelligent automation.

For portfolio and more projects:  
🔗 [https://www.vishnuvinayan.com](https://www.vishnuvinayan.com)

---

© 2025 RMK Experts | Built with ❤️ using Next.js, Prisma & TailwindCSS
