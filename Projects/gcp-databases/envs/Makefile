# Your project name. This has to be globally unique, since this is used to
# store Terraform remote state. Once you have deployed infrastructure, you
# cannot change this name without loosing your project state. Contact CloudCore
# team if you really need to change this variable.
# It must not be set to the default of CHANGEME, run make init for guidance.
PROJECTNAME = "gds::gcp-databases::3301"
SERVICENAME = "daas"
OWNERNAME = "gds@groupon.com"

# If you want to change the Terragrunt version, update this var. It will
# automatically be installed when it is executed the next time.
TERRAGRUNT_VERSION := 0.30.7

# Overwrite default TF-Base backend region (default us-west-2)
# TF_BACKEND_REGION := us-west-2

# Which cloud provider? (default is AWS)
CLOUD_PROVIDER := GCP

# Version of compliance tests used. See https://github.groupondev.com/CloudCore/terraform-base-compliance/releases for details
COMPLIANCE_TEST_VERSION := v0.4

# Compliance test level ("recommended" will run both "mandatory" and "recommended" compliance tests)
COMPLIANCE_TEST_LEVEL := recommended

# This will disable compliance tests being run with each terraform plan
DISABLE_AUTOMATIC_COMPLIANCE_TESTS := true

# Include CloudCore Terraform tooling
-include .terraform-tooling/Makefiles/*

# ############################################################################ #
#                  Below is room for your custom make targets                  #
# ############################################################################ #

# If your project depends on custom software, you can hook into the standard
# install procedure by defining below target.
# It will be automatically triggered when a user calls `make install` or
# `make setup`
#
#custom-dependencies:
	# some-custom-command
#
# Furthermore you can hook into the formatting targets by defining below
# targets. Docs: https://pages.github.groupondev.com/CloudCore/terraform-base/content/formatting.html
#
#custom-format:
#	@autopep8 --in-place --aggressive --aggressive some/file
#
#custom-format-check:
#	@autopep8 --diff --aggressive --aggressive some/file
#
#custom-pre-commit:
#	@cd $(PROJECT_ROOT) && git diff --cached --name-only --diff-filter=ACM -z -- '*.py' | xargs -L1 autopep8 --diff --aggressive --aggressive
