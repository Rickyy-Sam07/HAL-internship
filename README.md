# 🚀 FastAPI + IIS Auto-Startup Integration Guide (Windows)

This guide explains how to run a FastAPI backend automatically on Windows, integrated with IIS (Internet Information Services) using NSSM (Non-Sucking Service Manager) and Application Request Routing (ARR) for reverse proxying.

It ensures that your FastAPI app runs automatically whenever the system starts — no need to manually execute `uvicorn main:app --reload` every time.

## 🧩 Prerequisites

- Windows 10/11 or Server with Administrator privileges
- Python 3.8+ installed and added to PATH
- FastAPI app (example: `main.py`)
- IIS Installed with these modules:
  - ✅ URL Rewrite
  - ✅ Application Request Routing (ARR)
- NSSM (Non-Sucking Service Manager) downloaded from [https://nssm.cc/download](https://nssm.cc/download)

## ⚙️ Step-by-Step Setup

### 1. 🧱 Install IIS and Required Modules

Open "Turn Windows features on or off"

Enable:
- Internet Information Services
- IIS Management Console

Download and install:
- URL Rewrite Module
- Application Request Routing

> 💡 After installing ARR, restart your computer to ensure IIS loads ARR correctly.

### 2. 🧠 Verify Modules

Open IIS Manager → Server Name (Home) and confirm:
- You see "URL Rewrite" and
- "Application Request Routing Cache"

If you only see them at the server level but not under Default Web Site, that's okay — ARR works globally.

### 3. 🪄 Prepare FastAPI App

Example: `C:\FastAPIApp\main.py`

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI via IIS!"}
```

Make sure it runs fine manually first:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

Check at: `http://127.0.0.1:8000`

### 4. 🧰 Install NSSM

Extract `nssm.exe` to a folder, for example:
```
C:\nssm\nssm.exe
```

Add that folder to your PATH environment variable, or navigate there in CMD.

### 5. ⚡ Create FastAPI Windows Service

Run Command Prompt (Admin):
```cmd
nssm install FastAPI_Service
```

In the NSSM GUI:
- **Path**: `C:\Users\<YourUser>\AppData\Local\Programs\Python\Python39\python.exe`
- **Startup directory**: `C:\FastAPIApp`
- **Arguments**: `-m uvicorn main:app --host 0.0.0.0 --port 8000`

Click **Install service** ✅

### 6. ▶️ Start the Service

```cmd
nssm start FastAPI_Service
```

You can check the status:
```cmd
nssm status FastAPI_Service
```

If it runs successfully, your app is now hosted on port 8000 automatically!

### 7. 🌐 Configure IIS Reverse Proxy

1. Open IIS Manager
2. Click **Default Web Site**
3. In the right pane, click "URL Rewrite"
4. Click "Add Rule(s)… → Reverse Proxy"
5. Enter your FastAPI backend address: `127.0.0.1:8000`
6. Enable:
   - ✅ "Enable SSL Offloading" (optional)
   - ✅ "Preserve host header"

> ⚠️ If you get `Error: Configuration section can only be set in ApplicationHost.config`, then open `C:\Windows\System32\inetsrv\config\ApplicationHost.config` and ensure this section exists:
> ```xml
> <section name="proxy" overrideModeDefault="Allow" allowDefinition="AppHostOnly" />
> ```
> Save, restart IIS, and try again.

### 8. ✅ Test Your Setup

Now open: `http://localhost/`

You should see the FastAPI response — without specifying any port!

### 9. 🔄 Automatic Startup on Boot

Both services now start automatically:
- NSSM FastAPI_Service runs Python and Uvicorn on startup
- W3SVC (IIS) runs automatically with Windows

You can verify your FastAPI service is set to auto-start:
```cmd
sc config FastAPI_Service start= delayed-auto
```

## 🧹 Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `ctlscript.bat` not recognized | Leftover Bitnami installation | Delete `C:\Bitnami\` folder completely |
| Port 80 already in use | Old web server running | Stop or uninstall Bitnami / Apache |
| Can't see "Reverse Proxy" in rules | ARR not installed or IIS restart needed | Reinstall ARR + URL Rewrite and restart IIS |
| Error: "Configuration section can only be set in ApplicationHost.config" | Proxy section not allowed in site config | Add `<section name="proxy" overrideModeDefault="Allow" />` to ApplicationHost.config |
| FastAPI doesn't run on startup | NSSM service failed | Check service logs with `eventvwr.msc` |
| Only accessible via 127.0.0.1:8000 | Reverse proxy not configured properly | Redo the URL Rewrite reverse proxy rule |
| FastAPI restarting too quickly | Wrong Python path or working directory | Edit service in NSSM and fix paths |

## 🧭 Optional Enhancements

- **🧊 Serve frontend (HTML/React)** via IIS root, proxy only `/api/*` to FastAPI
- **🔒 Add HTTPS** using win-acme (Let's Encrypt for Windows)
- **🧠 Use logs**: `C:\nssm\service\FastAPI_Service\stdout.log` and `stderr.log` for debugging

## 🏁 Summary

✅ FastAPI runs as a background Windows service  
✅ IIS handles all HTTP traffic and proxies it to FastAPI  
✅ Automatic startup with Windows boot  
✅ No manual uvicorn command needed  
✅ Easily extensible for production environments