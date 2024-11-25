#!/bin/bash

echo "Starting OpenShift automation script for ArgoCD and Tekton..."

# Run ArgoCD installation
echo "Installing ArgoCD..."
bash install_argocd.sh

# Run Tekton installation
echo "Installing Tekton Pipelines..."
bash install_pipelines.sh

echo "Automation complete!"
