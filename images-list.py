import os
from keystoneauth1 import loading
from keystoneauth1 import session
from novaclient import client
from pprint import pprint

VERSION = 2
USERNAME = os.environ['OS_USERNAME']
AUTH_URL = os.environ['OS_AUTH_URL']
PASSWORD = os.environ['OS_PASSWORD']
PROJECT_NAME = os.environ['OS_PROJECT_NAME']
USER_DOMAIN_NAME = os.environ['OS_USER_DOMAIN_NAME']
PROJECT_DOMAIN_NAME = os.environ['OS_PROJECT_DOMAIN_NAME']

loader = loading.get_plugin_loader('password')
auth = loader.load_from_options(
        auth_url=AUTH_URL, username=USERNAME, password=PASSWORD,
        project_name=PROJECT_NAME, project_domain_name=PROJECT_DOMAIN_NAME,
        user_domain_name=USER_DOMAIN_NAME

    )
sess = session.Session(auth=auth)
nova = client.Client(VERSION, session=sess)
pprint(nova.glance.list())
