#!/usr/bin/env python

from json import load
import pickle
from sklearn.tree import DecisionTreeClassifier

# [1] Pickle
# Using pickle you can save and load Python
# object, including machine learning models

model = DecisionTreeClassifier(min_samples_leaf=500)

# Save the model
with open('model.pkl','wb') as file:
    pickle.dump(model, file)

# Load the model
with open('model.pkl','rb') as file:
    loaded_model = pickle.load(file)

# [2] Joblib
# This is a very efficient module for saving and loading
# large NumPy arrays and objects. 
# Preferred for scikit-learn models.

import joblib

# Save the model
joblib.dump(model, 'model.joblib')

# Load the model
loaded_model = joblib.load('model.joblib')

# [3] HDF5
# Great for deep learning models created with
# libraries like TenorFlow or Keras.

from keras.models import load_model

# Save the model
model.save('model.h5')

# Load the model
loaded_model = load_model('model.h5')

# [4] JSON or YAML
# Save model architecture and weights in JSON or YAML
# formats for better readability and sharing model
# details.

# Save model architecture to JSON
model_json = model.to_json()
with open('model.json', 'w') as json_file:
    json_file.write(model_json)

# Save model weights to HDF5
model.save_weights('model_weights.h5')

# Load model architecture from JSON and load weights
from keras.models import model_from_json

with open('model.json','r') as json_file:
    loaded_model_json = json_file.read()

loaded_model = model_from_json(loaded_model_json)
load_model.load_weights('model_weights.h5')

# [5] ONNX (Open Neural Network Exchange):
# An open format for representing machine learning
# models. Model can be converted from various 
# frameworks to ONNX and save them for
# interoperability.

import onnx
from onnx import numpy_helper

# Save a scikit-learn model to ONNX format
onnx_model = convert_sklearn(model, 'MyModel')
onnx.save_model(onnx_model, 'model.onnx')

# Load the ONNX model
loaded_model = onnx.load('model.onnx')
