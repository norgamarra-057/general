## */gcp-login: Retrieve temporary GCP credentials via gcloud,              e.g. sandbox/gcp-login
%/gcp-login: .gcp-profile/%
ifeq ($(CLOUD_PROVIDER),GCP)
	@gcloud auth application-default login && \
	gcloud config set project ${GCP_PROJECT_ID}
else 
	@echo "WARNING: No action performed. This project is not configurd to use GCP."
endif

## */gcp-logout: Stop the GCP session,              e.g. sandbox/gcp-logout
%/gcp-logout: .gcp-profile/%
ifeq ($(CLOUD_PROVIDER),GCP)
	@gcloud auth revoke
else 
	@echo "WARNING: No action performed. This project is not configurd to use GCP."
endif
