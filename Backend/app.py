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

# Giải thích chi tiết
explanations = {
    0: "Ảnh cho thấy đây là <b>pin</b> thuộc nhóm <b>Rác thải điện tử</b>.",
    1: "Ảnh cho thấy đây là <b>thực phẩm thừa, vỏ trái cây, rau củ</b> thuộc nhóm <b>Rác thải hữu cơ</b>.",
    2: "Ảnh cho thấy đây là <b>bìa cứng</b> thuộc nhóm <b>Rác thải tái chế</b>.",
    3: "Ảnh cho thấy đây là <b>vải</b> thuộc nhóm <b>Rác thải công nghiệp</b>.",
    4: "Ảnh cho thấy đây là <b>thủy tinh</b> thuộc nhóm <b>Rác thải tái chế</b>.",
    5: "Ảnh cho thấy đây là <b>vật dụng kim loại</b> thuộc nhóm <b>Rác thải tái chế hoặc công nghiệp</b>.",
    6: "Ảnh cho thấy đây là <b>giấy</b> thuộc nhóm <b>Rác thải tái chế</b>.",
    7: "Ảnh cho thấy đây là <b>nhựa</b> thuộc nhóm <b>Rác thải tái chế hoặc sinh hoạt</b>.",
    8: "Ảnh cho thấy đây là <b>giày</b> thuộc nhóm <b>Rác thải tái chế hoặc sinh hoạt</b>.",
    9: "Ảnh cho thấy đây là <b>rác thải hỗn hợp</b> thuộc nhóm <b>Rác thải sinh hoạt</b>.",
}

# Hướng dẫn xử lý
instructions = {
    0: "👉 Hãy mang pin đến các điểm thu gom rác thải điện tử để xử lý đúng cách.",
    1: "👉 Có thể dùng rác hữu cơ để ủ phân compost hoặc bỏ vào thùng rác hữu cơ.",
    2: "👉 Bìa cứng có thể gấp gọn và bỏ vào thùng rác tái chế giấy.",
    3: "👉 Vải cũ có thể tái sử dụng hoặc quyên góp nếu còn dùng được.",
    4: "👉 Thủy tinh nên rửa sạch và bỏ vào thùng rác tái chế thủy tinh.",
    5: "👉 Kim loại có thể tái chế – hãy đưa đến cơ sở thu gom kim loại.",
    6: "👉 Giấy sạch nên được phân loại để tái chế.",
    7: "👉 Nhựa nên được rửa sạch và bỏ vào thùng tái chế nhựa.",
    8: "👉 Giày cũ có thể tặng lại hoặc bỏ đúng nơi quy định nếu không dùng nữa.",
    9: "👉 Rác hỗn hợp nên được bỏ vào thùng rác sinh hoạt, tránh lẫn với tái chế.",
}

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
            'explanation': explanations.get(predicted_index, ""), # mô tả chi tiết loại rác
            'instruction': instructions.get(predicted_index, "") # hướng dẫn xử lý
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
