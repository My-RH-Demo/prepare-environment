#!/bin/bash

# Namespace and Operator name
TEKTON_NAMESPACE="openshift-pipelines"

# Install Tekton Operator
echo "Installing Tekton Pipelines Operator..."
oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators
spec:
  channel: pipelines-1.14
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF

# Wait for Operator installation
echo "Waiting for Tekton Pipelines Operator to be ready..."
sleep 60  # Adjust this based on your cluster speed.

# Verify installation
echo "Verifying Tekton Pipelines installation..."
oc get pods -n $TEKTON_NAMESPACE

echo "Tekton Pipelines is installed!"

