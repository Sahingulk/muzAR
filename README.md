# MuzAR - Museum AR Guide 🎨📱

MuzAR, ziyaretçilerin müze deneyimini artırmak için artırılmış gerçeklik (AR), yapay zeka ile eser tanıma ve Firebase tabanlı kullanıcı yönetimi sunan modern bir Flutter uygulamasıdır.

![MuzAR Preview](https://your-app-screenshot-url.com)

## ✨ Özellikler

- 📸 **Eser Tanıma (AI Model ile)**: Kamera ile çekilen fotoğraflardan eserleri otomatik tanıma (TFLite destekli).
- 🧠 **AR ile Bilgi Baloncuğu**: Taranan eserlerin açıklamalarını 3D bilgi küpü ile AR ortamında gösterme.
- 🗺️ **AR Güzergah / Yol Takip**: Ziyaretçilere artırılmış gerçeklik ile güzergah gösterimi.
- 💾 **Firebase Tabanlı Kullanıcı Yönetimi**:
  - E-posta ile giriş/kayıt
  - Kullanıcı profili
  - Geçmiş eserler
  - Favori eserler
- 📊 **Firestore ile Dinamik Veri**: Müze listeleri, eser açıklamaları, AR içerikleri ve kullanıcı verileri bulut tabanlı yönetilir.
- 🎨 **Gelişmiş UI/UX**: Responsive ve tema destekli modern tasarım (dark/light mod uyumlu).
- 📂 **Model Yönetimi**: Her müze için özel GLB model bağlantıları, uzaktan yüklenir.

## 📸 Ekran Görüntüleri

| Giriş & Kayıt | Müze Seçimi | Eser Tanıma | AR Güzergah |
|--------------|-------------|-------------|-------------|
| ![](screenshots/login.png) | ![](screenshots/museums.png) | ![](screenshots/scan.png) | ![](screenshots/arpath.png) |

## 🛠️ Kurulum

### 1. Flutter Yüklü mü?

```bash
flutter doctor
