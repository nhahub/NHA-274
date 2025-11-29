# Dry run to see what would be deployed
helm install my-proshop . --dry-run --debug

# Template the chart to see the final YAML
helm template my-proshop .

# Install to your cluster
helm install my-proshop .

# Check the status
helm status my-proshop

# List all releases
helm list

# Package the chart into a .tgz file
helm package .
