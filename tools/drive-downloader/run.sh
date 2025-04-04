#!/bin/sh

# Exit on first error
set -e

# Get venv path
venv="${DD_VENV_PATH:-./venv}/bin/activate"

# Activate venv
source $venv

# Run main
python main.py

# Deactivate venv
deactivate
