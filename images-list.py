import os
from osauth import os_session, VERSION
from novaclient import client
from pprint import pprint


nova = client.Client(VERSION, session=os_session)
pprint(nova.glance.list())
