.PHONY: install ssh

ssh:
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.5 && \
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.6 && \
	ssh-keygen -f /home/ubuntu/.ssh/known_hosts -R 10.1.1.7

install:
	ansible-playbook -i hosts site.yml
