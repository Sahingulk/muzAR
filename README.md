

-----

# MuzAR - Museum AR Guide 🎨📱

MuzAR, ziyaretçilerin müze deneyimini artırmak için **artırılmış gerçeklik (AR)**, **yapay zeka ile eser tanıma** ve **Firebase tabanlı kullanıcı yönetimi** sunan yenilikçi bir Flutter uygulamasıdır.

Bu proje, müzeleri keşfetmeyi daha etkileşimli ve bilgilendirici hale getirmeyi hedefler.

-----

## ✨ Temel Özellikler

  * **📸 Eser Tanıma (AI Destekli)**: Uygulama, kamera ile çekilen fotoğraflardan eserleri otomatik olarak tanımak için **TensorFlow Lite (TFLite)** destekli bir yapay zeka modeli kullanır.
  * **🧠 AR ile Bilgi Baloncuğu**: Taranan eserlerin detaylı açıklamaları, 3D bilgi küpleri şeklinde artırılmış gerçeklik ortamında gösterilir.
  * **🗺️ AR Güzergah ve Yol Takibi**: Ziyaretçiler, müze içinde artırılmış gerçeklik ile görsel olarak yönlendirilir, bu da keşfetmeyi kolaylaştırır.
  * **💾 Firebase Tabanlı Kullanıcı Yönetimi**:
      * E-posta ile hızlı giriş ve kayıt.
      * Kapsamlı kullanıcı profili yönetimi.
      * Ziyaret edilen eserlerin geçmişini takip etme.
      * Favori eserleri kaydetme özelliği.
  * **📊 Firestore ile Dinamik Veri Yönetimi**: Müze listeleri, eser açıklamaları, AR içerikleri ve kullanıcı verileri gibi tüm bilgiler bulut tabanlı Firestore veritabanında dinamik olarak yönetilir.
  * **🎨 Gelişmiş UI/UX**: Duyarlı ve modern bir kullanıcı arayüzü sunar. Uygulama, hem **karanlık (dark)** hem de **aydınlık (light)** temaları destekler.
  * **📂 Dinamik GLB Model Yönetimi**: Her müze için özel GLB (3D model) bağlantıları uzaktan yüklenerek içerik esnekliği sağlanır.

-----

## 📸 Ekran Görüntüleri

| Giriş & Kayıt | Müze Seçimi | Eser Tarama | AR Güzergahı |
| :------------ | :---------- | :---------- | :------------ |
|  |  |  |  |

-----

## 🛠️ Kurulum Talimatları

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

### 1\. Flutter Yüklü mü?

Terminalinizde aşağıdaki komutu çalıştırarak Flutter kurulumunuzu kontrol edin:

```bash
flutter doctor
```

Eğer yüklü değilse, [Flutter resmi web sitesinden](https://flutter.dev/docs/get-started/install) kurulum yönergelerini takip edin.

### 2\. Depoyu Klonlayın

Projeyi GitHub'dan klonlayın ve proje dizinine gidin:

```bash
git clone https://github.com/SahinGulk/muzAR.git
cd muzAR
```

### 3\. Firebase Bağlantısı Kurun

1.  [Firebase Console](https://console.firebase.google.com/) üzerinden yeni bir Firebase projesi oluşturun.
2.  Projenize Android ve iOS uygulamaları ekleyin.
3.  Oluşturulan `google-services.json` dosyasını `android/app/` dizinine kopyalayın.
4.  Oluşturulan `GoogleService-Info.plist` dosyasını `ios/Runner/` dizinine kopyalayın.
5.  Firestore'da aşağıdaki koleksiyonları oluşturduğunuzdan emin olun (bu koleksiyonlar uygulamanın çalışması için gereklidir):
      * `museums`
      * `artworks`
      * `users/{userId}/visitedArtworks`
      * `users/{userId}/favorites`

### 4\. Bağımlılıkları Yükleyin

Proje bağımlılıklarını indirmek için aşağıdaki komutu çalıştırın:

```bash
flutter pub get
```

### 5\. Uygulamayı Başlatın

Uygulamayı çalıştırmak için:

```bash
flutter run
```

*Not: iOS için ek olarak `pod install` ve Xcode ayarları (gerekli yetkilendirmeler ve uygulama imzalama) yapmanız gerekebilir.*

-----

## 📁 Proje Yapısı (MVVM + Provider)

MuzAR projesi, temiz kod prensipleri ve ölçeklenebilirlik göz önünde bulundurularak **MVVM (Model-View-ViewModel)** mimarisi ve **Provider** ile durum yönetimi kullanılarak yapılandırılmıştır:

```
lib/
├── core/             # Uygulama genel ayarları (temalar, renkler, sabitler)
├── models/           # Veritabanı ve API'den gelen veri modelleri
├── providers/        # State yönetimi için kullanılan Provider sınıfları (ViewModel'ler)
├── screens/          # Tüm kullanıcı arayüzü (UI) ekranları
├── services/         # Firebase, TTS (Text-to-Speech), AI sınıflandırma gibi servis katmanları
└── widgets/          # Uygulama genelinde tekrar kullanılabilir UI bileşenleri
```

-----

## 🧪 Kullanılan Teknolojiler

Bu projenin geliştirilmesinde başlıca şu teknolojiler ve kütüphaneler kullanılmıştır:

  * **Flutter**: Çapraz platform mobil uygulama geliştirme framework'ü.
  * **Firebase**: Kimlik doğrulama (Auth), bulut veritabanı (Firestore) ve depolama (Storage) hizmetleri.
  * **AR Flutter Plugin (ar\_flutter\_plugin)**: Flutter'da artırılmış gerçeklik deneyimleri oluşturmak için.
  * **TensorFlow Lite (tflite\_flutter)**: Mobil cihazlarda makine öğrenimi modellerini çalıştırmak için.
  * **Provider**: Flutter uygulamalarında durum yönetimi için basit ve güçlü bir çözüm.

-----

## 🙌 Katkıda Bulunma

MuzAR projesine her türlü katkı ve iyileştirme önerisine açığız\! 🎉

  * Hata bulursanız veya bir özellik öneriniz varsa, lütfen bir **issue** açmaktan çekinmeyin.
  * Koda katkıda bulunmak isterseniz, **pull request** gönderebilirsiniz.

Fikirleriniz veya başka bir sorunuz olursa benimle iletişime geçebilirsiniz.

-----

## 📄 Lisans

Bu proje **MIT Lisansı** altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakınız.

© 2025 Sahin Gulk

-----

Ekran görüntüleri yüklencek

-----
