## :
## : APPLY, plan, and destroy commands have an optional PARALLEL=N argument to set the number of concurrent Terraform operations.
## :

## */validate: Run validate-all on specified path,              e.g. sandbox/us-west-2/validate
%/validate: .gcp-profile/%
	@$(MAKE) .terragrunt-xargs TARGETDIR="$(*)" ACTION="validate-all $(EXCLUDE_QUARANTINE_OPTIONS)"

## */plan: Run plan-all on specified path,                  e.g. sandbox/us-west-2/plan
%/plan: .gcp-profile/%
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="plan-all -out=./plan.output $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS) $(TARGET_OPTION)"; \
	if [[ "$(DISABLE_AUTOMATIC_COMPLIANCE_TESTS)" == "false" ]]; then $(MAKE) $(*)/test-compliance SKIP_TF_PLAN=true; fi

## */plan-destroy-all: Run plan-all on specified path,                  e.g. sandbox/us-west-2/plan-destroy-all
%/plan-destroy-all: .gcp-profile/%
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="plan-all --destroy $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS)"

## */plan-destroy: Run plan on specified path,                      e.g. sandbox/us-west-2/specific_module/plan-destroy
%/plan-destroy: .gcp-profile/%
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="plan --destroy $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS) $(TARGET_OPTION)"

## */APPLY: Run apply-all on specified path,                 e.g. sandbox/us-west-2/APPLY
%/APPLY: .gcp-profile/%
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="apply-all $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS) $(TARGET_OPTION)"

## */DESTROY-ALL: Run destroy-all on specified path,               e.g. sandbox/us-west-2/DESTROY-ALL
%/DESTROY-ALL: .gcp-profile/%
	@echo -n "WARNING: Module dependencies(if any defined in the terragrunt) will also be removed. Be sure you first run a plan-destroy-all to see what will be destroyed. Are you sure you want to DESTROY $(*)? [y/N] " && read ans && [ $${ans:-N} == y ]
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="destroy-all $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS)"

## */DESTROY: Run destroy on specified path,                   e.g. sandbox/us-west-2/specific_module/DESTROY
%/DESTROY: .gcp-profile/%
	@echo -n "Be sure you first run a plan-destroy to see what will be destroyed. Are you sure you want to DESTROY $(*)? [y/N] " && read ans && [ $${ans:-N} == y ]
	@$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="destroy $(EXCLUDE_QUARANTINE_OPTIONS) $(PARALLELISM_OPTIONS) $(TARGET_OPTION)"

%/init: .gcp-profile/%
	@find $(*) -not -path '*/.terragrunt-cache/*' -type f -name terraform.tfvars | while read line; do \
		DIR=$$(dirname $$line); \
		echo "Processing '$${DIR}'"; \
		$(MAKE) .terragrunt-xargs GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" TARGETDIR="$${DIR}" ACTION="init"; \
	done

## */console: Starts interactive terraform console,            e.g. sandbox/global/console
%/console: .gcp-profile/%
	@$(MAKE) .terragrunt GCP_PROJECT_NUMBER="$(GCP_PROJECT_NUMBER)" GCP_PROJECT_ID="$(GCP_PROJECT_ID)" GCP_ENV_STAGE="$(GCP_ENV_STAGE)" GCP_TF_SA=$(GCP_TF_SA) TARGETDIR="$(*)" ACTION="console" AWS_PROFILE=$(AWS_PROFILE)
