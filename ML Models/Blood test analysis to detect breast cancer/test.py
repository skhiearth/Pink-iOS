import requests

data = {'data': "48,23.5,70,2.707,0.467408667,8.8071,9.7024,7.99585,417.114"}
r = requests.post("https://bcpd3.herokuapp.com/predict", json=data)
print('response from server:', r)
