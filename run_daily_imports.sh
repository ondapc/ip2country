#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/daily_imports_$(date +%F).log"

# Use the virtual environment if available, otherwise fall back to system Python.
if [[ -x "$SCRIPT_DIR/.venv/bin/python" ]]; then
  PYTHON="$SCRIPT_DIR/.venv/bin/python"
else
  PYTHON="python3"
fi

SCRIPTS=(
  "import_asin_ip.py"
  "import_asin_ipv6.py"
  "import_city_ip.py"
  "import_city_ipv6.py"
  "import_country_ip.py"
  "import_country_ipv6.py"
)

echo "=== Daily import started at $(date +'%Y-%m-%d %H:%M:%S') ===" | tee -a "$LOG_FILE"

for script in "${SCRIPTS[@]}"; do
  echo "--- Running $script ---" | tee -a "$LOG_FILE"
  if [[ ! -f "$SCRIPT_DIR/$script" ]]; then
    echo "ERROR: Script not found: $script" | tee -a "$LOG_FILE"
    exit 1
  fi

  if ! "$PYTHON" "$SCRIPT_DIR/$script" 2>&1 | tee -a "$LOG_FILE"; then
    echo "ERROR: $script failed" | tee -a "$LOG_FILE"
    exit 1
  fi

  echo "--- Completed $script ---" | tee -a "$LOG_FILE"
  echo "" | tee -a "$LOG_FILE"
done

echo "=== Daily import finished at $(date +'%Y-%m-%d %H:%M:%S') ===" | tee -a "$LOG_FILE"
