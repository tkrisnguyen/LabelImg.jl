# Deployment Guide - Server Hosting

## Option A: Local Network (Classroom/Lab)

### Requirements
- Your computer stays on during annotation session
- Students on same WiFi/network

### Steps

1. **Find your IP address:**
```powershell
ipconfig
# Look for IPv4 Address, e.g., 192.168.1.100
```

2. **Start server:**
```julia
include("src/LabelImg.jl")
LabelImg.start(8080)
```

3. **Configure firewall** (Windows):
```powershell
New-NetFirewallRule -DisplayName "LabelImg" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
```

4. **Share URL with students:**
```
http://YOUR_IP_ADDRESS:8080
```
Example: `http://192.168.1.100:8080`

### Student Instructions
"Open browser and go to: http://192.168.1.100:8080 (replace with actual IP)"

### Limitations
- ⚠️ No concurrent editing (students take turns)
- ⚠️ Your computer must stay running
- ⚠️ Only works on same network

---

## Option B: Cloud Hosting (Internet Access)

### B1. Railway.app (Free Tier: 500 hours/month)

1. **Create account:** https://railway.app
2. **Install Railway CLI** (optional) or use web dashboard
3. **Deploy:**
   ```bash
   # Install Railway CLI
   npm i -g @railway/cli
   
   # Login
   railway login
   
   # Create new project
   railway init
   
   # Deploy
   railway up
   ```

4. **Configure:**
   - In Railway dashboard, add environment variable: `PORT=8080`
   - Enable public domain
   - Copy the generated URL (e.g., `your-app.up.railway.app`)

5. **Share URL with students**

**Pros:** Free tier, easy deployment
**Cons:** 500 hours/month limit, may sleep after inactivity

---

### B2. Render.com (Free Tier)

1. **Create account:** https://render.com
2. **Create new Web Service**
3. **Connect your GitHub repo** (push LabelImg to GitHub first)
4. **Configure:**
   - Environment: Docker
   - Or use Build Command: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
   - Start Command: `julia --project=. -e 'include("src/LabelImg.jl"); LabelImg.start(parse(Int, get(ENV, "PORT", "8080"))))'`

5. **Deploy and copy URL**

**Pros:** Free tier, auto-deploy from GitHub
**Cons:** Spins down after 15 min inactivity (cold start ~1 min)

---

### B3. DigitalOcean / Linode / Vultr ($4-6/month)

1. **Create droplet** (Ubuntu 22.04)
2. **SSH into server**
3. **Install Julia:**
```bash
wget https://julialang-s3.julialang.org/bin/linux/x64/1.12/julia-1.12.4-linux-x86_64.tar.gz
tar zxvf julia-1.12.4-linux-x86_64.tar.gz
sudo ln -s ~/julia-1.12.4/bin/julia /usr/local/bin/julia
```

4. **Upload your code:**
```bash
git clone https://github.com/yourusername/LabelImg.jl.git
cd LabelImg.jl
```

5. **Install dependencies:**
```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

6. **Run server (with systemd for auto-restart):**
```bash
# Create service file
sudo nano /etc/systemd/system/labelimg.service
```

Content:
```ini
[Unit]
Description=LabelImg Server
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/home/youruser/LabelImg.jl
ExecStart=/usr/local/bin/julia --project=. -e 'include("src/LabelImg.jl"); LabelImg.start(8080)'
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl enable labelimg
sudo systemctl start labelimg

# Configure firewall
sudo ufw allow 8080
```

7. **Access via:** `http://your_server_ip:8080`

**Pros:** Full control, always on, fast
**Cons:** Costs money, requires server management

---

### B4. Heroku (Free tier discontinued)

No longer recommended due to pricing changes.

---

## Recommendation

**For quick testing:** Local Network (Option A)
**For class assignment:** Railway.app or Render.com (free tier)
**For production/heavy use:** DigitalOcean droplet ($6/month)

## Multi-User Support

⚠️ **Current version doesn't support concurrent users!** 

Each student accessing the same server shares the same project state. For multi-user:

**Simple solution:** Deploy multiple instances
- Instance 1: `https://labelimg-student1.railway.app`
- Instance 2: `https://labelimg-student2.railway.app`
- etc.

**Better solution:** Each student uses their own project name and image directory path. They won't interfere with each other.

## Testing Your Deployment

1. Start server
2. Open browser to the URL
3. Create a test project
4. Verify image loading and annotation works
5. Check Save functionality
6. Share URL with students

## Firewall Rules

**Windows:**
```powershell
New-NetFirewallRule -DisplayName "LabelImg" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
```

**Linux (ufw):**
```bash
sudo ufw allow 8080
```

**Cloud providers:** Configure security group/firewall to allow port 8080

## Support Script for Students

Create a simple status page:
```
Server URL: http://your-server:8080
Status: ✅ Online

Instructions:
1. Click the link above
2. Create your project with YOUR NAME as project name
3. Use your assigned image folder
4. Annotate and save

If you can't connect:
- Check if URL is correct
- Try refreshing browser
- Contact teacher: [your-email]
```

---

Need help with specific deployment platform? Let me know!
