build_number=30
crypto:
	cd ansible && ansible-vault encrypt vault.yaml --vault-password-file $(HOME)/.vault_secret
	
ami:
	# make sure old ami and snapshots are removed before run
	cd terraform-ami && terraform init
	cd terraform-ami && terraform plan 
	cd terraform-ami && terraform apply --auto-approve
	cd ansible && ansible-playbook deploy-docker-container.yaml --vault-password-file ~/.vault_secret --extra-vars="image_tag=$(build_number)"
	cd terraform-ami && python3 create_custom_ami.py
	cd terraform-ami && terraform destroy --auto-approve

autoscale:
	cd terraform && terraform init
	cd terraform && terraform plan 
	cd terraform && terraform apply --auto-approve

destroy_autoscale:
	cd terraform && terraform destroy --auto-approve