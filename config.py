#!/usr/bin/python3
import paramiko
import threading
import time
import os

def remote_run(ip,username,passwd,cmd):
	try:
		ssh=paramiko.SSHClient()
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		ssh.connect(ip,22,username,passwd,timeout=5)
		for m in cmd:
			print(ip,m)
			stdin,stdout,stderr=ssh.exec_command(m)
			err=stderr.readlines()
			for e in err:
				print(ip,e)
		ssh.close()
	except:
		print(ip,'remote_run Error')

def remote_run_key(hostn, usern, privatekey, cmd):
	try:
		ssh=paramiko.SSHClient()
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		k=paramiko.RSAKey.from_private_key_file(privatekey)
		ssh.connect(hostname=hostn, username=usern, pkey=k)
		for m in cmd:
			print(hostn, m)
			stdin,stdout,stderr=ssh.exec_command(m)
			err = stderr.readlines()
			for e in err:
				print(hostn, m, e)
		ssh.close()
	except:
		print(hostn, 'remote_run_key Error')

def remote_fetch(ip,port,username,passwd,remote_file,local_file):
	try:
		transport=paramiko.Transport((ip,port))
		transport.connect(username=username,password=passwd)
		sftp=paramiko.SFTPClient.from_transport(transport)
		sftp.get(remote_file,local_file)
		sftp.close()
		transport.close()
	except:
		print(ip,'remote_fetch Error')

def remote_fetch_key(hostn, usern, privatekey,remote_file,local_file):
	try:
		ssh=paramiko.SSHClient()
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		k = paramiko.RSAKey.from_private_key_file(privatekey)
		ssh.connect(hostname=hostn, username=usern, pkey=k)
		sftp=ssh.open_sftp()
		sftp.get(remote_file,local_file)
		sftp.close()
		ssh.close()
	except:
		print(hostn, 'remote_fetch_key Error')

def remote_push(ip,port,username,passwd,local_file,remote_file):
	try:
		transport=paramiko.Transport((ip,port))
		transport.connect(username=username,password=passwd)
		sftp=paramiko.SFTPClient.from_transport(transport)
		sftp.put(local_file,remote_file)
		sftp.close()
		transport.close()
	except:
		print(ip,'remote_push Error')

def ssh_config_run(host,cmd):
	ssh = paramiko.SSHClient()
	ssh.load_system_host_keys()
	ssh._policy = paramiko.WarningPolicy()
	#ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

	ssh_config = paramiko.SSHConfig()
	user_config_file = os.path.expanduser("~/.ssh/config")
	try:
		with open(user_config_file) as f:
			ssh_config.parse(f)
	except:
		print("{} file could not be found. Aborting.".format(user_config_file))
		sys.exit(1)
	user_config = ssh_config.lookup(host)
	cfg = {'hostname': user_config['hostname'], 'username': user_config['user'], 'look_for_keys': False}

	if 'proxycommand' in user_config:
		cfg['sock'] = paramiko.ProxyCommand(user_config['proxycommand'])

	ssh.connect(**cfg)
	for m in cmd:
		print(host,m)
		if m[:4] == 'sudo':
			transport = ssh.get_transport()
			session = transport.open_session()
			session.set_combine_stderr(True)
			session.get_pty()
			session.exec_command(m)
			stdin = session.makefile('wb', -1)
			stdout = session.makefile('rb', -1)
			stdin.write('Ranchyang!1\n')
			stdin.flush()
			for line in stdout.read().splitlines():        
				print 'host: %s: %s' % (host, line)
			continue
		stdin,stdout,stderr=ssh.exec_command(m)
		outt = stdout.readlines()
		for o in outt:
			print(host,'out',o)
		err=stderr.readlines()
		for e in err:
			print(host,'err',e)
	ssh.close()

if __name__=='__main__':
	cmd0 = [
			'sudo apt-get update',
			'sudo apt-get install -y apt-transport-https curl',
			'sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -',
			'sudo sh -c \'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list\'',
			'sudo apt-get update',
			'sudo apt-get install -y kubelet kubeadm kubectl',
			'sudo apt-mark hold kubelet kubeadm kubectl',
			]
	cmd = [
			'sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates curl software-properties-common',
			'sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -',
			'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"',
			'sudo apt-get update && sudo apt-get install docker-ce=18.06.2~ce~3-0~ubuntu',
			]
	paramiko.util.log_to_file("paramiko.log")
	ssh_config_run("compute04",cmd)
	ssh_config_run("compute05",cmd)
	ssh_config_run("compute06",cmd)
