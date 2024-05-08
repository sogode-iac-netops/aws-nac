import boto3
from botocore.config import Config
import json
from simple_term_menu import TerminalMenu
import requests
from requests import Request, Session
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# Defaults
spokes_network_start = "10.0.0.0"
spoke_vpc_prefix_len = 22
phpipam_credentials_file = 'phpipam.json'
sesh = Session()

def get_ipam_sections():
    # Get sections from IPAM
    controller = "sections/"
    req = sesh.get(globals()['phpipam_base'] + controller)
    if req.status_code == 200 and 'data' in req.json():
        return req.json()['data']
    else:
        return False

def get_section_id():
    sections = get_ipam_sections()
    if not sections:
        # No existing sections, no base deployed yet
        return False
    elif len(sections) > 1:
        terminal_menu = TerminalMenu(
            [f"{d['name']}: {d['description']}"  for d in sections],
            title = 'Select the section to create networks in'
            )
        menu_entry_index = terminal_menu.show()
        return sections[menu_entry_index]['id']
    else:
        return sections[0]['id']
    
def get_aws_region_name():
#    names = get_aws_region_names()
#    terminal_menu = TerminalMenu(
#        names,
#        title = "Select region"
#        )
#    menu_entry_index = terminal_menu.show()
#    return names[menu_entry_index]
    return 'eu-west-1'

def get_aws_region_names():
    # Retrieve all regions
    boto = boto3.client('ec2')
    regions = boto.describe_regions()
    region_names = []
    # Discard anything other than RegionName
    for region in regions['Regions']:
        region_names.append(region['RegionName'])

    return region_names

def get_aws_az_names(region):
#    names = get_aws_availability_zones_names(region)
#    output = []
#    terminal_menu = TerminalMenu(
#        names,
#        title = "Select 2 Availability Zones",
#        multi_select = True,
#        show_multi_select_hint = True
#        )
#    menu_entry_indices = terminal_menu.show()[:2]
#    for i in menu_entry_indices:
#        output.append(names[i])
#    return output
    return ['eu-west-1a', 'eu-west-1b']

def get_aws_availability_zones_names(region):
    # Get availability zones for the regions
    zones = []

    # Client needs to be re-initiated as it only returns AZs for the current region
    boto = boto3.client('ec2', config = Config(region_name = region))
    response = boto.describe_availability_zones()
    for zone in response['AvailabilityZones']:
        if zone['State'] == 'available':
            zones.append(zone['ZoneName'])
    del boto
    return zones
    
def get_subnets_from_section(sectionId):
    # Retrieve existing supernets in section
    controller = "sections/"
    req = sesh.get(globals()['phpipam_base'] + controller + str(sectionId) + '/subnets/')
    if req.status_code == 200 and 'data' in req.json():
        return req.json()['data']
    else:
        return False

def get_supernet(sectionId, regionName):
    # Return the id of the supernet in which to create subnets
    supernets = get_subnets_from_section(sectionId)
    options = []
    if not supernets:
        # No region deployed yet
        return False
    else:
        # Pick any of the existing ones
        for supernet in supernets:
            if supernet['description'] == regionName:
                options.append(supernet['subnet'] + '/' + supernet['mask'])
        if len(options) > 1:
            terminal_menu = TerminalMenu(
                options,
                title = "Select supernet"
                )
            menu_entry_index = terminal_menu.show()
        else:
            menu_entry_index = 0
        # Find subnet
        subnet = options[menu_entry_index].split('/')[0]
        mask = options[menu_entry_index].split('/')[1]
        for supernet in supernets:
            if supernet['subnet'] == subnet and supernet['mask'] == mask:
                return supernet['id']

def create_ipam_vpc_cidr(supernetId, region_name, app_name):
    controller = "subnets/"
    endpoint = f"{supernetId}/first_subnet/{str(spoke_vpc_prefix_len)}/"
    data = {
        "description": f"Spoke VPC: {app_name} {region_name}"
    }
    req = sesh.post(globals()['phpipam_base'] + controller + endpoint, data=json.dumps(data))
    if req.status_code == 201:
        subnet = {
            'cidr': req.json()['data'],
            'description': data['description'],
            'ipam_id': req.json()['id']
        }
    else:
        subnet = False
    return subnet

def get_app_name():
    app_name = input("Enter the name of the application: ")
    return app_name

def create_subnets(supernetId, availability_zones):
    controller = "subnets/"
    scopes = ["Local", "TransitGateway"]
    scopes_prefix_len = [24, 28]
    subnets = []

        # Create different scopes of networks
    s = 0
    while s < len(scopes):
        # Iterate through 2 availability zones
        az = 0
        while az < 2:
            endpoint = f"{supernetId}/first_subnet/{str(scopes_prefix_len[s])}/"
            data = {
                "description": f"Subnet {az + 1} AZ {availability_zones[az]}"
            }
            req = sesh.post(globals()['phpipam_base'] + controller + endpoint, data=json.dumps(data))
            if req.status_code == 201:
                subnet = {
                    'cidr': req.json()['data'],
                    'description': data['description'],
                    'availability_zone': availability_zones[az],
                    'ipam_id': req.json()['id'],
                    'scope': scopes[s].lower()
                }
                subnets.append(subnet)
            az += 1
        s += 1
    return subnets

def main():
    sectionId = get_section_id()
    region_name = get_aws_region_name()
    availability_zones = get_aws_az_names(region_name)
    app_name = get_app_name()
    supernetId = get_supernet(sectionId, region_name)
    if not supernetId == False:
        vpc_cidr = create_ipam_vpc_cidr(supernetId, region_name, app_name)
        subnets = create_subnets(vpc_cidr['ipam_id'], availability_zones)
        output = {
            'region_name': region_name,
            'application_name': app_name,
            'vpc_cidr': vpc_cidr['cidr'],
            'vpc_description': vpc_cidr['description'],
            'availability_zones': availability_zones,
            'subnets': subnets
        }
    
        with open(f"ipam_spoke_{region_name}-{app_name}.json".lower().replace(" ", "_"), 'w') as f:
            json.dump(output, f)
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
