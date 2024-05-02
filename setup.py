import boto3
from botocore.config import Config
import json
from simple_term_menu import TerminalMenu
import requests
from requests import Request, Session
from requests.packages.urllib3.exceptions import InsecureRequestWarning
import ipaddress

# Assumptions
first_supernet_cidr = "10.0.0.0/11"
amount_of_regions = 2
subnet_prefix = 26 # Length of subnets in VPC
phpipam_credentials_file = 'phpipam.json'
outfile_name = 'blueprint.json'

output = {'vpcs': {}}
sesh = Session()

def merge_dictionaries(dict1, dict2):
    merged_data = {}

    # Merge dict1 into merged_data
    for key, value in dict1.items():
        if key in merged_data:
            merged_data[key].update(value)
        else:
            merged_data[key] = value

    # Merge dict2 into merged_data
    for key, value in dict2.items():
        if key in merged_data:
            merged_data[key].update(value)
        else:
            merged_data[key] = value
    
    return merged_data

def select_regions():
    terminal_menu = TerminalMenu(
        get_aws_region_names(),
        title = f"Select {amount_of_regions} regions",
        multi_select = True,
        show_multi_select_hint = True
        )
    menu_entry_indices = terminal_menu.show()
    return terminal_menu.chosen_menu_entries[:amount_of_regions]

def get_aws_region_names():
    # Retrieve all regions
    boto = boto3.client('ec2')
    regions = boto.describe_regions()
    region_names = []
    # Discard anything other than RegionName
    for region in regions['Regions']:
        region_names.append(region['RegionName'])

    return region_names

def get_aws_availability_zones(regions):
    # Get availability zones for the regions
    zones = {}

    for region in regions:
        # Client needs to be re-initiated as it only returns AZs for the current region
        boto = boto3.client('ec2', config = Config(region_name = region))
        response = boto.describe_availability_zones()
        temp = {region: []}
        for zone in response['AvailabilityZones']:
            if zone['State'] == 'available' and zone['RegionName'] == region:
                temp[region].append(zone['ZoneName'])
        zones.update(temp)
        del boto
    return zones
    
def create_ipam_section():
    # Create a section in phpipam to store subnets in
    controller = "sections/"
    data = {
        "name": "NaC-AWS",
        "description": "Network as Code - AWS",
        "permissions": "{\"2\":\"2\",\"3\":\"1\"}"
    }
    req = sesh.post(globals()['phpipam_base'] + controller, data=json.dumps(data))
    if req.status_code == 201:
        return req.json()['id']
    else:
        return False

def calculate_subnet_cidrs(amount):
    # This calculates the supernets from the first_supernet variable
    cidrs = [first_supernet_cidr]
    i = 1
    while i < amount:
        previous_subnet = ipaddress.IPv4Network(cidrs[i-1])
        new_cidr = str(ipaddress.IPv4Address(previous_subnet.broadcast_address) + 1) + '/' + str(previous_subnet.prefixlen)
        cidrs.append(new_cidr)
        i += 1
    
    return cidrs

def create_supernets(sectionId, regions):
    # Reserve supernets for each of the regions
    cidrs = calculate_subnet_cidrs(amount_of_regions)
    ret = True
    supernets = []
    controller = "subnets/"
    i = 0
    while i < len(cidrs):
        data = {
            "subnet": cidrs[i].split('/')[0],
            "mask": cidrs[i].split('/')[1],
            "description": f"Region {i + 1}: {regions[i]}",
            "sectionId": sectionId
        }
        req = sesh.post(globals()['phpipam_base'] + controller, data=json.dumps(data))
        if req.status_code == 201:
            vpc = {
                regions[i]: {
                    'cidr': cidrs[i],
                    'description': 'Base VPC'
                }
            }
            supernet = {
                'id': req.json()['id'],
                'sectionId': sectionId,
                'cidr': cidrs[i],
                'region': regions[i]
            }
            output['vpcs'].update(vpc)
            supernets.append(supernet)
        else:
            ret = False
        i += 1
    
    if ret:
        return supernets
    else:
        return ret

def create_subnets(supernets, availability_zones):
    controller = "subnets/"
    ret = True
    scopes = ["Private", "Public"]

    # Iterate through supernets (regions)
    r = 0
    while r < len(supernets):
        # Iterate through 2 availability zones
        az = 0
        endpoint = f"{supernets[r]['id']}/first_subnet/{subnet_prefix}/"
        region = supernets[r]['region']
        subnets = {region: {'subnets': []}}
        while az < 2:
            # Create different scopes of networks
            s = 0
            while s < len(scopes):
                data = {
                    "description": f"{scopes[s]} subnet {az + 1} AZ {availability_zones[region][az]}"
                }
                req = sesh.post(globals()['phpipam_base'] + controller + endpoint, data=json.dumps(data))
                if req.status_code == 201:
                    subnet = {
                        'cidr': req.json()['data'],
                        'description': data['description'],
                        'availability_zone': availability_zones[region][az],
                        'ipam_id': req.json()['id']
                    }
                    subnets[region]['subnets'].append(subnet)
                s += 1
            az += 1
        output['vpcs'] = merge_dictionaries(output['vpcs'], subnets)
        r += 1

def write_result(filename):
    with open(filename, 'w') as file:
        json.dump(output, file, indent = 4)

def main():
    regions = select_regions()
    availability_zones = get_aws_availability_zones(regions)
    supernets = create_supernets(create_ipam_section(), regions)
    subnets = create_subnets(supernets, availability_zones)
    write_result(outfile_name)
    print(f"{json.dumps(output)}\n")

if __name__ == "__main__":
    with open (phpipam_credentials_file) as f:
        j = json.load(f)
    globals().update(j)

    requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
    sesh.headers.update({'token': globals()['phpipam_token']})
    sesh.headers.update({'Content-Type': 'application/json'})
    sesh.verify = False
    # Verify connection to phpIPAM
    sesh.head(globals()['phpipam_base'])

    main()