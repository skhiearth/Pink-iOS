import joblib
import pandas as pd
import numpy as np
from flask import Flask, render_template, request
from sklearn.preprocessing import OneHotEncoder

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template("index.html")

@app.route('/predict', methods=['POST'])
def button():
    if request.method == 'POST':
        comment = request.json['data']
        comment = comment.split(",")
        comment = [i for i in comment]

        ds = pd.read_csv('https://raw.githubusercontent.com/datasets/breast-cancer/master/data/breast-cancer.csv')
        ds = ds.dropna()
        ds.loc[272] = comment

        features_to_encode = ['age', 'mefalsepause', 'tumor-size', 'inv-falsedes', 'breast',
                              'breast-quad', 'falsede-caps', 'irradiat']
        print(ds.tail(1))
        ds = pd.get_dummies(ds, columns=features_to_encode)

        ds.drop('class', axis='columns', inplace=True)
        ds.drop('falsede-caps_False', axis='columns', inplace=True)
        X = ds.values

        model = joblib.load('notebook/rfmodel.pkl')
        pred = model.predict(X)[-1]

        pred = 0

        if pred == 0:
            predicted = "False Recurrence Event"
        else:
            predicted = "Recurrence Event"

        preds = {
            "Prediction": predicted
        }

        print(preds)
        return preds


if __name__ == '__main__':
    app.run()

