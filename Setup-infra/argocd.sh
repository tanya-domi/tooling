# Connect to the cluster (kubeconfig update)
aws eks --region eu-north-1 update-kubeconfig --name eks-cloud

# Install ArgoCD
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

# Expose ArgoCD via LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Wait until LoadBalancer and secret are ready
echo "Waiting for ArgoCD server external hostname..."
until kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' | grep -qE '[a-z]'; do
  sleep 10
done
ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Waiting for ArgoCD admin secret..."
until kubectl -n argocd get secret argocd-initial-admin-secret >/dev/null 2>&1; do
  sleep 5
done
ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Login (requires argocd CLI to be installed beforehand)
argocd login "$ARGOCD_SERVER" --username admin --password "$ARGO_PWD" --insecure
echo "ArgoCD server is available at: $ARGOCD_SERVER"


