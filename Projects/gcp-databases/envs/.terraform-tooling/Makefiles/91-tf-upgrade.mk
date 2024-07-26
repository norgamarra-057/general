## :
## 0.13upgrade: Run 0.13upgrade on all environments from envs,   e.g. 0.13upgrade
0.13upgrade:
	@tfenv use 0.13.5
	@find ../modules -type f -name '*.tf' -print0 | xargs -0 -n1 dirname | sort --unique | while read dir; do \
		echo "running 'terraform 0.13upgrade -yes $${dir}'"; \
		terraform 0.13upgrade -yes $${dir}; \
	done


TARGETDIR="$(*)"

## Upgrade Issues? Rollback terraform.tfstate to previous version
## */rollback-state: rollback to the previous state, e.g. sandbox/us-west-2/example/rollback-state
%/rollback-state: .aws-profile/% .state-info/%
	@echo "Pull statefile from grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT)"
	@$(eval PREFIX := $(shell AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3api list-object-versions \
	                                                                            --bucket grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) \
	                                                                            --prefix  ${TARGETDIR} \
	                                                                            --max-items 2 | jq -r '.Versions[1].VersionId'))
	@echo "Found previous version of the file: ${PREFIX}"
	@echo "Pushing it to the s3 bucket"
	@AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3api get-object \
	                                                                --bucket grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) \
	                                                                --key ${TARGETDIR}/terraform.tfstate \
	                                                                --version-id ${PREFIX} terraform.tfstate &>/dev/null
	@AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3api put-object \
	                                                                --bucket grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) \
	                                                                --key ${TARGETDIR}/terraform.tfstate --body terraform.tfstate \
	                                                                --server-side-encryption AES256 &>/dev/null
	@$(eval ETag=`AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws s3api head-object \
	                                                                            --bucket grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT) \
	                                                                            --key ${TARGETDIR}/terraform.tfstate | jq -r '.ETag'`)
	@echo "Update ETag version of the file: $(ETag)"
	@AWS_DEFAULT_REGION=us-west-2 aws-okta exec $(AWS_PROFILE) -- aws dynamodb update-item --table-name grpn-${PROJECTNAME_LOWER}-lock-table-$(AWS_ACCOUNT) \
	                                                                    --key '{"LockID": {"S": "grpn-${PROJECTNAME_LOWER}-state-$(AWS_ACCOUNT)/$(subst $\",,$(TARGETDIR))/terraform.tfstate-md5"}}' \
	                                                                    --attribute-updates '{"Digest": {"Value": {"S": '$(ETag)'},"Action": "PUT"}}' \
	                                                                    --return-values UPDATED_NEW | jq '.Attributes.Digest.S'
