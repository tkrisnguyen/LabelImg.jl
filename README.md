# LabelImgJL

🏷️ **LabelImgJL** là một công cụ gắn nhãn hình ảnh được xây dựng bằng Julia, lấy cảm hứng từ Label Studio.

## ✨ Tính năng

- 🖼️ **Giao diện web hiện đại**: Giao diện trực quan, dễ sử dụng
- 📦 **Nhiều loại annotation**: Rectangle (hộp chữ nhật), Polygon (đa giác), Point (điểm)
- 🎨 **Quản lý nhãn**: Tạo và quản lý các nhãn tùy chỉnh
- 💾 **Lưu trữ JSON**: Xuất annotations sang định dạng JSON
- ⌨️ **Navigation nhanh**: Chuyển đổi giữa các hình ảnh dễ dàng
- 🎯 **Project-based**: Tổ chức công việc theo dự án

## 📋 Yêu cầu

- Julia 1.9 trở lên
- Các packages:
  - Genie.jl (web framework)
  - Images.jl (xử lý hình ảnh)
  - FileIO.jl (đọc/ghi file)
  - JSON3.jl (xử lý JSON)

## 🚀 Cài đặt

```julia
# Clone repository
git clone https://github.com/yourusername/LabelImgJL.git
cd LabelImgJL

# Activate project environment
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

## 💻 Sử dụng

### Cách 1: Chạy script example

```julia
julia example.jl
```

### Cách 2: Sử dụng trong REPL

```julia
using Pkg
Pkg.activate(".")

include("src/Interface.jl")
using .Interface

# Khởi động server trên port 8080
Interface.start(8080)
```

Sau đó mở trình duyệt và truy cập: `http://localhost:8080`

## 📖 Hướng dẫn sử dụng

1. **Tạo Project mới**:
   - Click nút "New Project"
   - Nhập tên project
   - Nhập đường dẫn thư mục chứa hình ảnh
   - Nhập các nhãn (cách nhau bằng dấu phẩy)
   - Click "Create"

2. **Gắn nhãn**:
   - Chọn một nhãn từ danh sách bên trái
   - Chọn công cụ: Rectangle, Polygon, hoặc Point
   - Vẽ annotation trên hình ảnh
   - Click "Save" để lưu

3. **Navigation**:
   - Sử dụng nút "Previous" và "Next" để di chuyển giữa các hình ảnh
   - Annotations được tự động lưu cho mỗi hình ảnh

4. **Các công cụ annotation**:
   - **Rectangle**: Click và kéo để vẽ hộp chữ nhật
   - **Polygon**: Click nhiều lần để vẽ đa giác, double-click để hoàn thành
   - **Point**: Click để đánh dấu một điểm

## 📁 Cấu trúc dữ liệu đầu ra

Annotations được lưu dưới dạng JSON:

```json
{
  "project": "My Dataset",
  "labels": ["cat", "dog", "person"],
  "annotations": [
    {
      "image": "/path/to/image.jpg",
      "annotations": [
        {
          "type": "rectangle",
          "label": "cat",
          "x": 100,
          "y": 150,
          "width": 200,
          "height": 180,
          "color": "#e74c3c"
        }
      ],
      "metadata": {
        "timestamp": "2026-02-09T10:30:00"
      }
    }
  ]
}
```

## 🎨 Tính năng nâng cao

- **Multiple annotations**: Có thể vẽ nhiều annotations trên một hình ảnh
- **Color coding**: Mỗi annotation tự động được gán màu khác nhau
- **Delete annotations**: Xóa annotations không mong muốn
- **Clear all**: Xóa tất cả annotations trên hình ảnh hiện tại

## 🔧 API Endpoints

- `GET /` - Giao diện web chính
- `POST /api/project/create` - Tạo project mới
- `GET /api/image/:index` - Lấy hình ảnh theo index
- `GET /api/image/next` - Chuyển đến hình ảnh tiếp theo
- `GET /api/image/prev` - Quay lại hình ảnh trước
- `POST /api/annotations/save` - Lưu annotations

## 🤝 Đóng góp

Contributions, issues và feature requests được chào đón!

## 📝 License

MIT License

## 🙏 Credits

Lấy cảm hứng từ [Label Studio](https://labelstud.io/) và [LabelImg](https://github.com/tzutalin/labelImg)