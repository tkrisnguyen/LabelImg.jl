# Hướng dẫn Đăng ký lên Julia General Registry

## 📋 Checklist Chuẩn bị (ĐÃ HOÀN THÀNH ✅)

- ✅ **LICENSE file** - MIT License đã được tạo
- ✅ **Authors trong Project.toml** - Đã thêm thông tin tác giả
- ✅ **Test suite** - Đã tạo test/runtests.jl với basic tests
- ✅ **Cấu trúc package** - Đúng chuẩn Julia package

## 🚀 Quy trình Đăng ký (7 Bước)

### Bước 1: Đẩy code lên GitHub

```bash
git add -A
git commit -m "Prepare for registry: add LICENSE, tests, and authors"
git push origin main1
```

### Bước 2: Tạo Release/Tag trên GitHub

1. Truy cập: https://github.com/tkrisnguyen/LabelImg/releases
2. Click **"Create a new release"**
3. Điền thông tin:
   - **Tag version**: `v0.1.0` (phải bắt đầu bằng 'v')
   - **Release title**: `v0.1.0 - Initial Release`
   - **Description**: Mô tả ngắn gọn về package
4. Click **"Publish release"**

### Bước 3: Cài đặt JuliaRegistrator

Trong Julia REPL:

```julia
using Pkg
Pkg.add("PkgDev")
```

### Bước 4: Đăng ký qua JuliaRegistrator Bot

**Phương pháp 1: Qua GitHub Comment (Khuyến nghị)**

1. Truy cập repository: https://github.com/tkrisnguyen/LabelImg
2. Tạo một **Issue mới** hoặc **Comment** trong một commit bất kỳ
3. Gõ comment sau:

```
@JuliaRegistrator register
```

4. JuliaRegistrator bot sẽ tự động:
   - Kiểm tra package
   - Tạo Pull Request đến General Registry
   - Thông báo kết quả

**Phương pháp 2: Qua Web Interface**

1. Truy cập: https://github.com/JuliaRegistries/Registrator.jl
2. Làm theo hướng dẫn sử dụng GitHub App

### Bước 5: Chờ Review

- Bot sẽ tự động kiểm tra package
- Nếu có lỗi, bot sẽ comment các vấn đề cần sửa
- Các maintainers của General Registry sẽ review
- Thời gian review: **3-7 ngày**

### Bước 6: Sửa lỗi (nếu có)

Nếu bot báo lỗi, thường là:

**Lỗi thường gặp:**

1. **UUID đã tồn tại**: Cần tạo UUID mới
   ```julia
   using UUIDs
   uuid4()  # Copy UUID mới vào Project.toml
   ```

2. **Test fail**: Sửa tests trong test/runtests.jl

3. **Compat missing**: Thêm compat cho tất cả dependencies
   ```toml
   [compat]
   julia = "1.9"
   Genie = "5"
   # ... (đã có)
   ```

4. **Repository URL**: Đảm bảo có trong Project.toml
   ```toml
   [sources]
   url = "https://github.com/tkrisnguyen/LabelImg.git"
   ```

### Bước 7: Merge & Hoàn thành

- Khi PR được approve, nó sẽ tự động merge
- Package sẽ có sẵn trong General Registry
- Người dùng có thể cài đặt:
  ```julia
  using Pkg
  Pkg.add("LabelImg")
  ```

## ⚠️ Lưu ý Quan trọng

### UUID Hiện tại
Package đang dùng UUID: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`

**⚠️ QUAN TRỌNG**: UUID này có vẻ là UUID demo/placeholder. 

**NÊN LÀM NGAY**: Tạo UUID mới và unique:

```julia
# Trong Julia REPL:
using UUIDs
uuid4()
```

Sau đó cập nhật vào [Project.toml](Project.toml):
```toml
uuid = "UUID-MỚI-VỪA-TẠO"
```

### Yêu cầu của General Registry

1. **Repository phải public**
2. **Có ít nhất 1 tag/release**
3. **Tests phải pass** (pkg> test)
4. **Documentation khuyến khích** (không bắt buộc lần đầu)
5. **Tên package không trùng** với packages khác

### Kiểm tra trước khi đăng ký

```julia
# Trong thư mục package
using Pkg
Pkg.activate(".")

# 1. Kiểm tra build
Pkg.build()

# 2. Chạy tests
Pkg.test()

# 3. Kiểm tra dependencies
Pkg.status()
```

## 📚 Tài liệu Tham khảo

- [Registrator.jl Guide](https://github.com/JuliaRegistries/Registrator.jl)
- [General Registry Guidelines](https://github.com/JuliaRegistries/General)
- [Julia Package Naming Guidelines](https://pkgdocs.julialang.org/dev/creating-packages/)

## 🆘 Troubleshooting

### "Package name already registered"
→ Chọn tên khác cho package

### "UUID collision"  
→ Tạo UUID mới bằng `uuid4()`

### "Tests failed"
→ Sửa tests để pass: `Pkg.test()`

### "Missing compat entries"
→ Thêm [compat] cho tất cả deps trong Project.toml

### "Repository not accessible"
→ Đảm bảo repo là public trên GitHub

## ✅ Checklist Cuối cùng

Trước khi chạy `@JuliaRegistrator register`:

- [ ] UUID là unique (không phải demo UUID)
- [ ] Đã push code lên GitHub
- [ ] Repository là PUBLIC
- [ ] Đã tạo tag/release v0.1.0
- [ ] Tests pass (`Pkg.test()`)
- [ ] LICENSE file có
- [ ] README.md có hướng dẫn rõ ràng
- [ ] Project.toml có đầy đủ: name, uuid, authors, version, [compat]

---

**Chúc bạn đăng ký thành công! 🎉**
