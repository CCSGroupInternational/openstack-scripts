import os

from cinderclient import client
from pprint import pprint
from osauth import os_session, VERSION

cinder = client.Client(VERSION, session=os_session)
pprint(cinder.volumes.list())

