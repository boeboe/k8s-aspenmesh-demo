.PHONY: install_k8s install_helm ssh

ssh:
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.5 && \
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.6 && \
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.7 && \
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.9

install_k8s:
	ansible-playbook -i hosts site.yml

install_helm:
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && \
	/usr/local/bin/helm completion bash >/etc/bash_completion.d/helm

