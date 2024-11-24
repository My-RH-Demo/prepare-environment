#!/bin/bash

# Set namespace and instance name
ARGOCD_NAMESPACE="argocd"
ARGOCD_INSTANCE="argocd-instance"

# Create namespace
echo "Creating namespace $ARGOCD_NAMESPACE..."
oc create namespace $ARGOCD_NAMESPACE || echo "Namespace $ARGOCD_NAMESPACE already exists."

# Install ArgoCD Operator
echo "Installing ArgoCD Operator..."
oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: argocd-operator
  namespace: openshift-operators
spec:
  channel: gitops-1.14
  name: openshift-gitops-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

# Wait for Operator installation
echo "Waiting for ArgoCD Operator to be ready..."
sleep 70  # Adjust this based on your cluster speed.

# Deploy ArgoCD instance
echo "Creating ArgoCD instance..."
oc apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: $ARGOCD_INSTANCE
  namespace: $ARGOCD_NAMESPACE
spec:
  server:
    route:
      enabled: true
EOF

# Expose ArgoCD Server
echo "Exposing ArgoCD Server..."
oc expose svc argocd-server -n $ARGOCD_NAMESPACE --name=argocd-external --port=http || echo "Route already exists."

# Output login information
echo "Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(oc get secret argocd-instance-cluster -n $ARGOCD_NAMESPACE -o jsonpath='{.data.admin\.password}' | base64 -d)
ARGOCD_ROUTE=$(oc get route argocd-instance-server -n $ARGOCD_NAMESPACE -o jsonpath='{.spec.host}')

echo "ArgoCD is installed!"
echo "URL: https://$ARGOCD_ROUTE"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"

