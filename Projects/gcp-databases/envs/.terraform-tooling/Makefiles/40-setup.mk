TOOLING_PATH := .terraform-tooling

## :
## init: Install requirements and configure project
init: .check-github-reachable
	@(>&2 printf "\nRunning Terraform Base project initialization. Running the below make commands:\n")
	@(>&2 printf "$(T_GREEN)make install$(T_NORMAL)        - installs Terraform Base dependencies\n$(T_GREEN)make setup-aws-okta$(T_NORMAL) - (optional) configures aws-okta\n$(T_GREEN)make project-config$(T_NORMAL) - customizes aspects of your project\n\n")
	@echo "" ; \
		read -p "Press Enter to continue.." enter_value
	
	@(>&2 printf "\n$(T_GREEN)## Step1$(T_NORMAL) - Running $(T_GREEN)make install$(T_NORMAL)\n")
	@$(MAKE) install
	@echo

	@(>&2 printf "\n$(T_GREEN)## Step2$(T_NORMAL) - Running $(T_GREEN)make setup-aws-okta$(T_NORMAL)\n")
	@(>&2 printf "This step will prompt you to configure aws-okta, which is required for authenticating API requests to AWS\n")
	@$(MAKE) setup-aws-okta

	@(>&2 printf "\n$(T_GREEN)## Step3$(T_NORMAL) - Running $(T_GREEN)make project-config$(T_NORMAL)\n")
	@(>&2 printf "This step will prompt you to customize aspects of your Terraform Base project to make it unique and applicable to your use case\n\n")
	@$(MAKE) project-config
	@(>&2 printf "\n$(T_GREEN)Setup complete!$(T_NORMAL)\n")

## install: Install requirements
install:
# if terragrunt was installed via brew, uninstall it, because we will use tgenv instead
	@if brew ls --versions terragrunt > /dev/null; then \
		echo "Uninstalling terragrunt..."; \
		brew uninstall terragrunt; \
	fi
# if terraform was installed via brew, uninstall it, because we will use tfenv instead
	@if brew ls --versions terraform > /dev/null; then \
		echo "Uninstalling terraform..."; \
		brew uninstall terraform; \
	fi
# install dependencies from Brewfile
	@echo "Installing Terraform Base dependencies..."
	@brew bundle --file=.terraform-tooling/Brewfile
# check if terraform is a binary file. if it is, it wasn't installed via tfenv. let the user know it needs to me manually fixed
	@TF_TYPE=$$(file -b --mime-type $$(command -v terraform) | sed 's|/.*||'); \
	if [[ "$${TF_TYPE}" != "text" ]]; then echo "ERROR: terraform ($${TF_TYPE}) was not installed via homebrew. You need to manually uninstall it and then run setup again!"; exit 1; fi
# install python dependencies
	@pip3 install terraform-compliance
# Install project specific dependencies
	@$(MAKE) custom-deps

custom-deps:
# Install project specific dependencies
	@$(MAKE) .custom-dependencies-if-defined

## setup-aws-okta: AD Password changed? Use this to update your okta credentials in your keychain.
setup-aws-okta:
	@echo -n "Do you want to configure aws-okta now? Only skip if you have already done this? [Y/n] " && read ans;\
	if [[ "$${ans:-Y}" == Y || "$${ans:-Y}" == y ]]; then \
		$(TOOLING_PATH)/bin/aws-okta-add; \
	fi

## aws-config: Generate AWS profile configuration
aws-config:
	@echo "Updating profiles in aws-cli config file ${AWS_CONFIG_FILE} "
	@echo
	@mkdir -p ~/.aws
	@.terraform-tooling/bin/gen-aws-config $(FEDERATED_AUTH_METHOD) $(SAML_URL) > ${AWS_CONFIG_FILE}

## update-tooling/*: Pull specific tooling version from CloudCore,    e.g. update-tooling/v1.0.0
update-tooling/%:
	$(eval URL := https://github.groupondev.com/CloudCore/gcp-terraform-base/archive/$(*).tar.gz)
	@(>&2 echo "Install Terraform Tooling $(*)...")
	@if ! curl -L --output /dev/null --silent --head --fail "$(URL)"; then \
	echo "$(*) does not exist or cannot be downloaded: $(URL)"; \
		exit 1; \
	fi
	@rm -rf $(TOOLING_PATH)/*
	@curl -# -Lqs $(URL) | tar -xzv --strip-components=2 "gcp-terraform-base-*/envs/.terraform-tooling"
	@(>&2 echo "Done")

## update-tooling: Pull latest tooling version from CloudCore
update-tooling: .check-github-reachable
	$(eval LATEST_VERSION := $(shell curl -s https://github.groupondev.com/api/v3/repos/CloudCore/gcp-terraform-base/tags | grep -m 1 name | cut -d '"' -f 4))
	@$(MAKE) update-tooling/$(LATEST_VERSION)

project-config: .check-github-reachable
	@(>&2 printf "Customizing your Terraform Base project with the below:\n")
	@(>&2 printf "$(T_GREEN)- Configuring your team name and project name$(T_NORMAL) - this is used to make your project name unique, relevant for naming Terraform Base backend resources\n")
	@(>&2 printf "$(T_GREEN)- Configuring your Service and Owner tag values$(T_NORMAL) - these are used to tag the Terraform Base backend resources\n")
	@(>&2 printf "$(T_GREEN)- Customizing your environment directory name and AWS account id$(T_NORMAL) - optional, in case you want to use anything different from the default\n\n")

	@echo -n "Do you want to customize your Terraform Base project now? Only skip if you have already done this [Y/n]" && read ans; \
		if [[ "$${ans:-Y}" == Y || "$${ans:-Y}" == y ]]; then \
			(>&2 printf "\n$(T_GREEN)Configuring your team name and project name..$(T_NORMAL)\n"); \
			(>&2 printf "Important to read:\n"); \
			(>&2 printf "* Even if you just want to quickly test something, $(T_UNDERLINE)this is not where you answer with \"test\" or \"foo\", so incorporate your login, project or team name for ideas$(T_NORMAL)!\n"); \
			(>&2 printf "* These values will be used to configure the remote statefile for your Terraform Base project.\n"); \
			(>&2 printf "* This process will let you know at the end if the values you have selected are unique and good to go\n\n"); \
			while [[ "$${team}" == "" ]]; do \
				read -p "Enter Team Name: " team; \
			done; \
			while [[ "$${project}" == "" ]]; do \
				read -p "Enter Project Name: " project; \
			done; \
			(>&2 printf "\n$(T_GREEN)Configuring your Service and Owner tag values..$(T_NORMAL)\n"); \
			(>&2 printf "Service and Owner tags are used for tracking ownership of resources in AWS. See the Groupon tagging policy for details.\n"); \
			(>&2 printf "Service value should be the value of your service from ServicePortal\n"); \
			(>&2 printf "Owner value should be your team email address\n\n"); \
			echo -n "Enter Service Name: " && read service; \
			SERVICENAME=$${service}; \
			echo -n "Enter Owner Name: " && read owner; \
			OWNERNAME=$${owner}; \
			(>&2 printf "\nSetting Service and Owner tag values....\n"); \
			sed -e "s/^\(SERVICENAME := \).*/\1$${SERVICENAME}/g" Makefile > Makefile.new; \
			mv Makefile.new Makefile; \
			sed -e "s/^\(OWNERNAME := \).*/\1$${OWNERNAME}/g" Makefile > Makefile.new; \
			mv Makefile.new Makefile; \
			echo "Your Service tag value is set to: $(T_GREEN)$${SERVICENAME}$(T_NORMAL)"; \
			echo "Your Owner tag value is set to: $(T_GREEN)$${OWNERNAME}$(T_NORMAL)"; \
			(>&2 printf "\n$(T_GREEN)Customizing your environment directory name and AWS account id..$(T_NORMAL)\n"); \
			(>&2 printf "This is an advanced feature, feel free to use the default as a safe place to start your project!\n"); \
			echo -n "Would you like to start with the default sandbox environment? This step will assign your project Gensandbox credentials. This can be modified later, if needed. [Y/n]" && read ans; \
			if [[ "$${ans:-Y}" == Y || "$${ans:-Y}" == y ]]; then \
				environment="sandbox"; \
				aws_account_id="549734399709"; \
				aws_default_role="grpn-sandbox-general-dev"; \
			else \
				while [[ "$${environment}" == "" ]]; do \
					read -p "Enter Environment Name: " environment; \
				done; \
				echo -n "Enter AWS Account ID [549734399709]: " && read aws_account_id; \
				echo -n "Enter AWS Default Role [grpn-sandbox-general-dev]: " && read aws_default_role; \
			fi; \
			(>&2 printf "\nCreating your environment directory...\n\n"); \
			cp -R ./.environment-template/ ./$${environment}/; \
			sed -e "s/^\(env_short_name = \).*/\1\"$${environment}\"/g" $${environment}/account.hcl > $${environment}/account.hcl.new; \
			mv $${environment}/account.hcl.new $${environment}/account.hcl; \
			if [[ "$${aws_account_id}" != "" ]];then \
				sed -e "s/^\(aws_account_id = \).*/\1\"$${aws_account_id}\"/g" $${environment}/account.hcl > $${environment}/account.hcl.new; \
				mv $${environment}/account.hcl.new $${environment}/account.hcl; \
			else \
				sed -e "s/^\(aws_account_id = \).*/\1\"549734399709\"/g" $${environment}/account.hcl > $${environment}/account.hcl.new; \
				mv $${environment}/account.hcl.new $${environment}/account.hcl; \
			fi; \
			if [[ "$${aws_default_role}" != "" ]];then \
				sed -e "s/^\(aws_default_role = \).*/\1\"$${aws_default_role}\"/g" global.hcl > global.hcl.new; \
				mv global.hcl.new global.hcl; \
			else \
				sed -e "s/^\(aws_default_role = \).*/\1\"grpn-sandbox-general-dev\"/g" global.hcl > global.hcl.new; \
				mv global.hcl.new global.hcl; \
			fi; \
			PROJECTNAME=$${team}::$${project}; \
			(>&2 printf "\nChecking your project identifier is $(T_GREEN)$${PROJECTNAME}$(T_NORMAL) is not already in use...\n"); \
			sed -e "s/^\(PROJECTNAME := \).*/\1$${PROJECTNAME}/g" Makefile > Makefile.new; \
			mv Makefile.new Makefile; \
			bucket_result=$$($(MAKE) aws-config $${environment}/.bucket-exists); \
			if [[ "$${bucket_result}" != *"404"* ]];then \
				printf "$(T_RED)ERROR: Project name $${PROJECTNAME} cannot be used!$(T_NORMAL) Please run $(T_BOLD)$(T_YELLOW)make project-config$(T_NORMAL) and select a different project name!\n\n"; \
				exit 1; \
			fi; \
			echo "Your Project name is now: $(T_GREEN)$${PROJECTNAME}$(T_NORMAL). You're good to go!"; \
		fi

## install-pre-commit-hook: Install pre-commit hook for validating format
install-pre-commit-hook:
	$(eval GIT_HOOK_PRE_COMMIT := "$(PROJECT_ROOT)/.git/hooks/pre-commit")
	@if [[ -f "$(GIT_HOOK_PRE_COMMIT)" ]]; then \
		echo "pre-commit already exists. Not going to modify it!"; \
		exit 1; \
	fi
	@echo "cd $(MAKEFILE_ROOT) && make .pre-commit" > "$(GIT_HOOK_PRE_COMMIT)"
	@chmod +x "$(GIT_HOOK_PRE_COMMIT)"
	@echo "Done"
