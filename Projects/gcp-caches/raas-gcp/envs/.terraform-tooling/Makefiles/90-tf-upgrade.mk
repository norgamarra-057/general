## :
## */backup-state: Create BACKUP bucket and clones all state files, e.g. sandbox/backup-state
%/backup-state: .aws-profile/% .state-info/%
	@echo "Creating bucket s3://grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT)-backup..."
	@AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3api create-bucket --bucket grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT)-backup --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 || true
	@echo "Syncronizing content from s3://grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) to s3://grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT)-backup..."
	@AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3 sync s3://grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) s3://backup-landing-zone-state-$(AWS_ACCOUNT)

## */0.12checklist: Run 0.12checklist on specified path,             e.g. sandbox/0.12checklist
%/0.12checklist: .aws-profile/%
	@find $(*) -not -path '*/.terragrunt-cache/*' -type f -name terraform.tfvars | while read line; do \
		DIR=$$(dirname $$line); \
		echo "Processing '$${DIR}'"; \
		$(MAKE) .terragrunt TARGETDIR="$${DIR}" ACTION="0.12checklist" AWS_PROFILE=$(AWS_PROFILE); \
	done

## 0.12upgrade: Run 0.12upgrade on all environments from envs,   e.g. 0.12upgrade
0.12upgrade:
	@tfenv use 0.12.7
	@find ../modules -type f -name '*.tf' -print0 | xargs -0 -n1 dirname | sort --unique | while read dir; do \
		echo "running 'terraform 0.12upgrade -yes $${dir}'"; \
		terraform 0.12upgrade -yes $${dir}; \
	done
