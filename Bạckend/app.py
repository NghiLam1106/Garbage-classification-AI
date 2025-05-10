import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
from PIL import Image
import numpy as np

app = Flask(__name__)
CORS(app)
app.config['MAX_CONTENT_LENGTH'] = 5 * 1024 * 1024

model = tf.keras.models.load_model("model/garbage-classification.keras")
CLASS_NAMES = ['battery', 'biological', 'cardboard', 'clothes', 'glass', 'metal', 'paper', 'plastic', 'shoes', 'trash']

def preprocess_image(image):
    image = image.resize((224, 224))  # chỉnh đúng với input shape của model bạn
    img_array = np.array(image) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    return img_array

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400
    
    file = request.files['image']
    if not file.filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        return jsonify({'error': 'Invalid image format'}), 400

    try:
        image = Image.open(file.stream).convert("RGB")
        processed = preprocess_image(image)
        prediction = model.predict(processed)[0]
        predicted_class = CLASS_NAMES[np.argmax(prediction)]
        confidence = float(np.max(prediction))

        return jsonify({
            'class': predicted_class,
            'confidence': round(confidence, 3),
            'probabilities': {CLASS_NAMES[i]: round(float(prediction[i]), 3) for i in range(len(CLASS_NAMES))}
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
