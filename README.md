# aws-nac
AWS Network As Code

# Software
awscli  
python3-boto  
python3-jsonschema  

- Ansible modules  
ansible.utils  
amazon.aws  

# Howto
1: Download, install and configure awscli  
This also makes sure you can log on to AWS in Python, Terraform and Ansible.
```
apt install awscli
aws configure
```

2: Create Python venv and activate it
```
python3 -m venv venv
source venv/bin/activate
```

3: install required software
```
venv/bin/pip3 install -r requirements.txt
```

4: Ensure phpipam.json exists with required information, see example here:
```
{
	"phpipam_token": "<token>",
	"phpipam_base": "https://localhost/api/<app_id/"
}
```

5: Run setup program to create section and networks in IPAM  
   It will create a file called `aws-base-blueprint.json` which is used to  
   create bases in 2 zones.
```
venv/bin/python3 setup.py
```