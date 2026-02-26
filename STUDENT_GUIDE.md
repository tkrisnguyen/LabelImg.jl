# LabelImg - Hướng dẫn Sinh viên / Student Guide

## 🇻🇳 Tiếng Việt

### Cách chạy chương trình

1. **Giải nén file** mà bạn đã tải về
2. **Vào thư mục** `bin`
3. **Double-click vào** `LabelImg.exe` (Windows) hoặc chạy `./LabelImg` (Linux/Mac)
4. **Mở trình duyệt** và truy cập: `http://localhost:8080`

### Hướng dẫn sử dụng

#### Bước 1: Tạo Project
1. Click nút **"New Project"**
2. Nhập:
   - **Project Name**: Tên dự án của bạn (ví dụ: "Assignment1")
   - **Image Directory**: Đường dẫn đến thư mục chứa ảnh cần gán nhãn
   - **Labels**: Các nhãn cần dùng, cách nhau bằng dấu phẩy (ví dụ: "beam, hinge, roller")
3. Click **"Create"**

#### Bước 2: Gán nhãn cho ảnh
1. **Chọn nhãn**: Click vào một nhãn trong danh sách bên trái
2. **Chọn công cụ**: 
   - 📦 **Rectangle** (Hình chữ nhật): Click và kéo chuột
   - ⯐ **Rotated Box** (Hộp xoay): Click 3 điểm - điểm A và B tạo cạnh đầu, điểm C hoàn thành hộp
   - 🔷 **Polygon** (Đa giác): Click chuột trái nhiều lần để thêm điểm, **click chuột phải để hoàn thành**
   - 📍 **Point** (Điểm): Click một lần
3. **Vẽ annotation** trên ảnh
4. Click **"Save"** để lưu kết quả

#### Bước 3: Chuyển ảnh
- Click nút **"Previous"** hoặc **"Next"** để xem ảnh khác
- Annotations được tự động lưu

#### Các nút chức năng
- **Clear**: Xóa tất cả annotations trên ảnh hiện tại
- **Save**: Lưu annotations (file JSON trong thư mục ảnh)
- Nút **🗑️** bên cạnh mỗi annotation: Xóa annotation đó

### Kết quả đầu ra

Sau khi Save, file JSON sẽ được tạo trong thư mục ảnh với tên `annotations_<tên_project>.json`

Nội dung có dạng:
```json
{
  "type": "rectangle",
  "label": "beam",
  "x": 100,
  "y": 200,
  "width": 300,
  "height": 150
}
```

Hoặc cho hộp xoay:
```json
{
  "type": "rotatedRect",
  "label": "beam",
  "points": [
    {"x": 100, "y": 200},
    {"x": 300, "y": 250},
    {"x": 280, "y": 350},
    {"x": 80, "y": 300}
  ]
}
```

### Khắc phục sự cố

**❌ Không mở được chương trình?**
- Thử chạy bằng Command Prompt: `LabelImgJL.exe 3000` (để đổi port)

**❌ Không thấy ảnh?**
- Kiểm tra đường dẫn thư mục ảnh có đúng không
- Đảm bảo ảnh có định dạng: jpg, png, bmp, hoặc gif

**❌ Port 8080 đã được sử dụng?**
- Chạy với port khác: `LabelImgJL.exe 3000`
- Sau đó mở: `http://localhost:3000`

---

## 🇬🇧 English

### How to Run

1. **Extract** the downloaded file
2. **Navigate to** the `bin` folder
3. **Double-click** `LabelImgJL.exe` (Windows) or run `./LabelImgJL` (Linux/Mac)
4. **Open browser** to: `http://localhost:8080`

### User Guide

#### Step 1: Create Project
1. Click **"New Project"** button
2. Enter:
   - **Project Name**: Your project name (e.g., "Assignment1")
   - **Image Directory**: Path to folder containing images
   - **Labels**: Comma-separated labels (e.g., "beam, hinge, roller")
3. Click **"Create"**

#### Step 2: Annotate Images
1. **Select label**: Click a label from the left sidebar
2. **Choose tool**: 
   - 📦 **Rectangle**: Click and drag
   - ⯐ **Rotated Box**: Click 3 points - points A and B form first edge, point C completes the box
   - 🔷 **Polygon**: Left-click to add points, **right-click to finish**
   - 📍 **Point**: Single click
3. **Draw annotation** on image
4. Click **"Save"** to save results

#### Step 3: Navigate Images
- Click **"Previous"** or **"Next"** to view other images
- Annotations are automatically saved

#### Buttons
- **Clear**: Delete all annotations on current image
- **Save**: Save annotations (JSON file in image folder)
- **🗑️** button next to each annotation: Delete that annotation

### Output

After Save, a JSON file will be created in the image folder named `annotations_<project_name>.json`

Format:
```json
{
  "type": "rectangle",
  "label": "beam",
  "x": 100,
  "y": 200,
  "width": 300,
  "height": 150
}
```

Or for rotated boxes:
```json
{
  "type": "rotatedRect",
  "label": "beam",
  "points": [
    {"x": 100, "y": 200},
    {"x": 300, "y": 250},
    {"x": 280, "y": 350},
    {"x": 80, "y": 300}
  ]
}
```

### Troubleshooting

**❌ Can't open the program?**
- Try running via Command Prompt: `LabelImgJL.exe 3000` (to change port)

**❌ Can't see images?**
- Check if image folder path is correct
- Ensure images are in format: jpg, png, bmp, or gif

**❌ Port 8080 already in use?**
- Run with different port: `LabelImgJL.exe 3000`
- Then open: `http://localhost:3000`

---

## 📧 Liên hệ / Contact

Nếu có vấn đề, liên hệ giáo viên hoặc email: [your-email@example.com]
