#!/usr/bin/env python2.7
import paramiko
import threading
import time
import os
import sys
from subprocess import call

def autorun(cmd):
    try:
        call(cmd,shell=True)
    except:
        print(cmd,'error')

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
                print(host, line)
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
    qps1 = '2'
    qps2 = '128'
    time1 = '60s'
    time2 = '60s'
    time3 = '150s'
    serviceip = 'http://172.16.20.103:30260/productpage'
    cmd0 = [
            'sudo apt-get update',
            'sudo apt-get install -y apt-transport-https curl',
            'sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -',
            'sudo sh -c \'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list\'',
            'sudo apt-get update',
            'sudo apt-get install -y kubelet kubeadm kubectl',
            'sudo apt-mark hold kubelet kubeadm kubectl',
            ]
    cmd1 = [
            'sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates curl software-properties-common',
            'sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -',
            'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"',
            'sudo apt-get update && sudo apt-get install docker-ce=18.06.2~ce~3-0~ubuntu',
            ]
    cmd = [
            'sudo ls',
            ]
    paramiko.util.log_to_file("paramiko.log")
    '''
    ssh_config_run("compute04",cmd)
    ssh_config_run("compute05",cmd)
    ssh_config_run("compute06",cmd)
    '''


    clear = [
            'sudo pkill -f tcpack_mod.py',
            'sudo pkill -f tcpin_mod.py',
            'sudo pkill -f fortio',
            'sudo rm /usr/local/bcc/tcpack_mod',
            'sudo rm /usr/local/bcc/tcpin_mod',
            ]
    ssh_config_run("compute04",clear)
    ssh_config_run("compute05",clear)
    ssh_config_run("compute06",clear)
    ssh_config_run("compute07",clear)
    print("clear")
    tcpack_mod = ['sudo timeout ' + time3 + ' python2.7 /home/yyang125/uBPF_tests/tcpack_mod.py -o']
    tcpin_mod = ['sudo timeout ' + time3 + ' python2.7 /home/yyang125/uBPF_tests/tcpin_mod.py -o']
    fortio = ['/home/yyang125/go/bin/fortio load -qps ' + qps1 + ' -t ' + time1 + ' ' + serviceip + '&& /home/yyang125/go/bin/fortio load -qps ' + qps2 + ' -t ' + time2 + ' ' + serviceip]

    a = [i for i in range(10)]
    c = [i for i in range(10)]
    b=threading.Thread(target=ssh_config_run,args=("compute07",fortio))
    for i in range(4,7):
        host = "compute0" + str(i)
        a[i]=threading.Thread(target=ssh_config_run,args=(host,tcpack_mod))
        c[i]=threading.Thread(target=ssh_config_run,args=(host,tcpin_mod))

    for i in range(4,7):
        a[i].start()
        c[i].start()

    print("uBPF starts")

    time.sleep(15)

    b.start()

    b.join()
    for i in range(4,7):
        a[i].join()
        c[i].join()
    
    print("experiment finished")
    autorun("scp compute04:/usr/local/bcc/tcpack_mod texts/org_ack04qps.txt")
    autorun("scp compute04:/usr/local/bcc/tcpin_mod texts/org_in04qps.txt")
    autorun("scp compute05:/usr/local/bcc/tcpack_mod texts/org_ack05qps.txt")
    autorun("scp compute05:/usr/local/bcc/tcpin_mod texts/org_in05qps.txt")
    autorun("scp compute06:/usr/local/bcc/tcpack_mod texts/org_ack06qps.txt")
    autorun("scp compute06:/usr/local/bcc/tcpin_mod texts/org_in06qps.txt")
    print("files fetched")
