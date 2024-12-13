#!/bin/bash

# Cluster names
clusters=("arbitration" "badges-service-cloud" "deckard-cache" "dispatcher-cache" "dlsvc-shield-cache" 
          "geo-bhuvan-cache-new" "geo-bhuvan-indexer" "goods-inventory-service" "lazlo-deals" "m3-placeread"
          "ugc-cache" "vis" "watson-deal-kv" "watson-freshness" "watson-user-kv" "wishlist")

# Deletion protection status (True or False in the same order as clusters)
protection_status=(False True True True True True True True True True True True True True True True)

REGION="europe-west1"

# Iterate over each cluster and its status
for i in "${!clusters[@]}"; do
  cluster_name="${clusters[$i]}"
  deletion_protection="${protection_status[$i]}"

  if [ "$deletion_protection" = "True" ]; then
    echo "Disabling deletion protection for cluster: $cluster_name"
    gcloud redis clusters update "$cluster_name" --region="$REGION" --no-deletion-protection
  else
    echo "Skipping cluster: $cluster_name (deletion protection is already disabled)"
  fi
done

