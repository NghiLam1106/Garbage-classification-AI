from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from tensorflow.keras.preprocessing.image import load_img, img_to_array
import tempfile
import os

app = Flask(__name__)

# Load model một lần duy nhất
model = tf.keras.models.load_model(
    r"E:\HOC_TAP\Nam_3\HOC_KY_2\Do_an_chuyen_nganh_1\source_code_hoc_may\soucre_code_chinh\Backend\model\garbage-classification.keras"
)

# Danh sách lớp rác
class_names = [
    'battery', 'biological', 'cardboard', 'clothes', 'glass',
    'metal', 'paper', 'plastic', 'shoes', 'trash'
]

# Giải thích chi tiết
explanations = {
    0: "Ảnh cho thấy đây là **pin** thuộc nhóm **Rác thải điện tử**.",
    1: "Ảnh cho thấy đây là **thực phẩm thừa, vỏ trái cây, rau củ** thuộc nhóm **Rác thải hữu cơ**.",
    2: "Ảnh cho thấy đây là **bìa cứng** thuộc nhóm **Rác thải tái chế**.",
    3: "Ảnh cho thấy đây là **vải** thuộc nhóm **Rác thải công nghiệp**.",
    4: "Ảnh cho thấy đây là **thủy tinh** thuộc nhóm **Rác thải tái chế**.",
    5: "Ảnh cho thấy đây là **vật dụng kim loại** thuộc nhóm **Rác thải tái chế hoặc công nghiệp**.",
    6: "Ảnh cho thấy đây là **giấy** thuộc nhóm **Rác thải tái chế**.",
    7: "Ảnh cho thấy đây là **nhựa** thuộc nhóm **Rác thải tái chế hoặc sinh hoạt**.",
    8: "Ảnh cho thấy đây là **giày** thuộc nhóm **Rác thải tái chế hoặc sinh hoạt**.",
    9: "Ảnh cho thấy đây là **rác thải hỗn hợp** thuộc nhóm **Rác thải sinh hoạt**.",
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
