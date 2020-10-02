import requests

data = {'data': "17.99,10.38,122.8,1001.0,0.1184"}
r = requests.post("https://bcpd.herokuapp.com/predict", json=data)
print('response from server:', r)
