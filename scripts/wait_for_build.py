import os
from time import sleep 

wait=10

for i in range(wait): 
    state = os.popen('kubectl get pods | grep build').read()
    if 'Running' in state:
        exit(0) 
    sleep(wait) 

print('Failed to deploy build in '+str(wait)+' seconds')
exit(1) 
