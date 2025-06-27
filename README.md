# 📊 Local Counter & File Converter

This is a simple local application consisting of:

- 🖥️ A **frontend** (`index.html`, CSS, JS) for interacting with the user.
- ⚙️ A **PowerShell-based API server** that:
  - Increments and decrements a number.
  - Converts `.txt` files to `.json`.

---

## 🚀 How to Run

### 1. Start the Server

Run the PowerShell server script to start the API:

```powershell
.\server.ps1
```

The server will start and listen for HTTP requests on a local port (e.g., `http://localhost:8080`).

### 2. Open the Frontend

Open `index.html` in any modern web browser (e.g., Chrome, Edge, Firefox).  
Simply double-click the file or open it via your browser’s file menu.

> ✅ No need for a web server — the frontend runs locally.

---

## 🧠 Features

- ✅ Display and update a number using **Increment** / **Decrement** buttons.
- 🔁 Maintain number state server-side via PowerShell.
- 🔄 Convert `.txt` files to `.json` with a single click.
- 🛑 Stop the API server cleanly using the **Stop Server** button.

---

## ⚙️ Requirements

- Windows OS with PowerShell
- Any modern web browser

---

## 📌 Notes

- This project is intended for **local use only**.
- There are **no internet dependencies** — it's self-contained.
- To extend functionality (e.g., track history, add logging, support other formats), edit `server.ps1` or other files as needed.

---

## 📂 Project Structure

```
.
├── client
│   ├── css
│   │   └── index.css
│   └── js
│       └── index.js
├── server
│   ├── converter.ps1
│   └── utils.ps1
├── server.ps1
├── index.html
└── README.md
```

---

## 🛠 API Endpoints

| Endpoint       | Method | Body            | Description                      |
| -------------- | ------ | --------------- | -------------------------------- |
| `/data`        | POST   | increment: True | Increments the number            |
| `/data`        | POST   | decrement: True | Decrements the number            |
| `/convert`     | POST   | None            | Converts `.txt` files to `.json` |
| `/stop_server` | POST   | None            | Stops the PowerShell server      |

---
