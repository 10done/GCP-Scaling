# VCC Assignment 3 — Monitoring & scale-out

- **`monitor.py`** — CPU/RAM monitoring (psutil), threshold + consecutive samples → `SCALE_SCRIPT`
- **`demo.sh`** — Runs monitor + `stress-ng` + shows audit log
- **`scale-out.sh`** → **`scale-out-local.sh`** — default: append scale event to `/tmp/vcc-scale.log`
- **`scale-out-gcp.sh`**, **`scale-out-aws.sh`**, **`scale-out-azure.sh`** — production CLI hooks
- **`app.py`** — sample Flask app on port 8080

## Quick run

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
chmod +x demo.sh scale-out.sh scale-out-local.sh scale-out-gcp.sh scale-out-aws.sh scale-out-azure.sh
./demo.sh
```

Cloud env template: `config/cloud.env.example` — copy to `config/cloud.env` (gitignored).
# GCP-Scaling
