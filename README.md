# SQL_e_devlet
Veritabanı yönetme, kurallı tablolar oluşturma ve pek çok ayrıntı eklediğim proje. Tüm kodları sıralı olarak verdim. 


**GELİŞTİRME AŞAMASI RAPORU**

**1. Projenin Amacı**
Bu projenin temel amacı, vatandaşların kamu kurumlarında yararlandığı hizmetlerin takip edilmesi, güvenlik analizinin yapılması ve araç kayıt bilgilerinin düzenli bir biçimde saklanmasıdır. Sistem, kullanıcıların gün içinde kaç hizmet kullandığını analiz ederek güvenlik risklerini belirlemeye yardımcı olur.

**2. Gereksinim Analizi**
Projenin başlangıç aşamasında kullanıcı gereksinimleri belirlenmiştir:
- Vatandaş bilgilerinin depolanması
- Hizmetlerin listelenmesi ve kullanım bilgilerinin tutulması
- Araç kayıt bilgilerinin yönetilmesi
- Günlük hizmet kullanım sınırının aşılması durumunda şüpheli kullanıcıların tespiti
- Sorgu, prosedür ve güvenlik kontrolleri

**3. Veritabanı Tasarımı**
ER Diyagramı tasarlanarak tablolar arasındaki ilişkiler belirlenmiştir:
- Vatandas: vatandaş bilgilerini tutar.
- Hizmet: hizmet adları ve numaralarını tutar.
- Hizmet_Kullanim: vatandaşların bir hizmeti ne zaman kullandığını kaydeder.
- Arac: her aracın plaka ve marka/model bilgilerini içerir.
- KayitliArac: vatandaş–araç ilişkisini temsil eder.

**4. Normalizasyon Süreci**
Başlangıçta karmaşık ve tekrarlı alanlar içeren bir tablo ele alınmış, 1NF, 2NF ve 3NF aşamalarından geçirilerek:
- Tekrarlı veri içeren alanlar parçalanmış
- Kısmi bağımlılıklar kaldırılmış
- Transitif bağımlılıklar ortadan kaldırılmış
- Sonuç olarak ilişkiselliği yüksek, tutarlı ve genişletilebilir tablolar elde edilmiştir.

**5. SQL Kodlarının Geliştirilmesi**
Proje kapsamında geliştirilen başlıca SQL unsurları:
- CREATE TABLE ifadeleri ile tablolar oluşturuldu.
- FOREIGN KEY tanımlarıyla ilişkiler kuruldu.
- Hizmet kullanım sayısını raporlayan prosedürler yazıldı.
- Bir vatandaşa ait araçları listeleyen prosedür oluşturuldu.

**6. Test Süreci**
Aşağıdaki kontroller yapılmıştır:
- Örnek veri girişleri ile tablo yapılarının doğruluğu test edildi.
- Prosedürlerin doğru sonuç verip vermediği kontrol edildi.
- Günlük hizmet limitinin aşımı durumunda şüpheli kategorisinin doğru belirlenip belirlenmediği test edildi.

**7. Sonuç ve Değerlendirme**
Projede hedeflenen tüm fonksiyonlar başarıyla gerçekleştirilmiştir:
- Veritabanı normalizasyon kurallarına uygundur.
- Tablolar arası ilişkiler doğru yapılandırılmıştır.
- Güvenlik amacıyla gerekli kullanım analizleri yapılmaktadır.
- Ek geliştirmelere uygun modüler bir yapı oluşturulmuştur.

Bu rapor, projenin analiz, tasarım ve geliştirme aşamalarını kapsamlı biçimde özetlemektedir.
