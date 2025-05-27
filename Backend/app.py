from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import tempfile
import os
from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

base_dir = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(base_dir, "../model/garbage-classification.keras")
# Load model một lần duy nhất
model = tf.keras.models.load_model(model_path)


# Danh sách lớp rác
class_names = [
    'battery', 'biological', 'cardboard', 'clothes', 'glass',
    'metal', 'paper', 'plastic', 'shoes', 'trash'
]

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Lưu tạm thời
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as tmp:
        file.save(tmp.name)
        temp_file_path = tmp.name

    try:
        # Tiền xử lý ảnh
        image = load_img(temp_file_path, target_size=(400, 400))
        x = img_to_array(image)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)

        # Dự đoán
        prediction = model.predict(x)[0]
        confidence = float(np.max(prediction))
        predicted_index = int(np.argmax(prediction))
        predicted_class = class_names[predicted_index]

        # Xoá ảnh sau khi xử lý
        os.remove(temp_file_path)

        if confidence < 0.5:
            return jsonify({
                'predicted_class': None,
                'confidence': confidence,
                'explanation': "Không xác định – Ảnh không rõ là loại rác nào.",
                'instruction': "Vui lòng thử lại với ảnh rõ hơn."
            })

        return jsonify({
            'predicted_class': predicted_class, # tên loại rác
            'confidence': confidence, # độ tin cậy
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=5000)
