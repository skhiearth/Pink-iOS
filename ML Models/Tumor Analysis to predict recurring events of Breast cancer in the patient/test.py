import requests

data = {'data': "50-59,premefalse,15-19,0-2,False,1,right,central,False,false-recurrence-events"}
r = requests.post("http://127.0.0.1:5000/predict", json=data)
print('response from server:', r)
