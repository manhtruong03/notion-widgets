# Notion Interactive Widgets Hub (`manhtruong03/notion-widgets`)

Kho lưu trữ tập trung các **Interactive HTML/JS Widgets** dùng để nhúng trực tiếp vào Notion thông qua khối `/embed` (GitHub Pages: `https://manhtruong03.github.io/notion-widgets/`).

## 1. Cấu trúc thư mục đa mục đích

```text
D:\manhtc\projects\notion-widgets\
├── index.html                  # Trang chủ Gallery: Tìm kiếm, xem thử & Copy link /embed
├── registry.json               # Danh mục tập trung toàn bộ widgets
├── shared\
│   ├── notion-theme.css        # Hệ màu tự động khớp Notion Light (#FFFFFF) & Notion Dark (#191919)
│   └── notion-widget.js        # Hỗ trợ ?theme=dark|light và nút chuyển giao diện Sáng/Tối
├── scripts\
│   └── publish-widget.ps1      # Script tự động gắn theme, cập nhật registry.json và git push
└── widgets\
    ├── learning\               # Mô phỏng kiến trúc, sơ đồ tương tác, học tập (<course-slug>/)
    ├── work\                   # Micro-tools cho kỹ thuật, dự án (BrSE, Dev, QA)
    ├── productivity\           # Quản lý thời gian, tiến độ, tracker cá nhân
    └── utilities\              # Công cụ tính toán, biểu đồ đa năng
```

## 2. Xuất bản nhanh 1 Widget mới lên GitHub Pages

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\manhtc\projects\notion-widgets\scripts\publish-widget.ps1" `
  -Id "<unique-widget-id>" `
  -Title "<Tiêu đề Widget>" `
  -Category "learning" `
  -Group "aws-saa-c03" `
  -Description "<Mô tả ngắn>" `
  -SourceHtmlPath "<đường-dẫn-file-html>" `
  -TargetFileName "<tên-file.html>" `
  -Tags @("aws", "saa-c03")
```
