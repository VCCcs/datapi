deploy:
	terraform -chdir=infra init
	terraform -chdir=infra apply -auto-approve
	chmod 600 infra/test_key.pem

destroy:
	terraform -chdir=infra destroy -auto-approve