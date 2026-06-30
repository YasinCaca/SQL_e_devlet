create database if not exists E_Devlet;
use E_Devlet;

drop table if exists ilk_sifre;
drop table if exists sifreler;
drop table if exists Vatandaslar;

create table Vatandaslar (
    id VARCHAR(11) not null primary key,
    ad VARCHAR(30),
    soyad VARCHAR(20)
);

drop trigger if exists vatandaslar_before_insert;
DELIMITER $$
create trigger vatandaslar_before_insert
BEFORE INSERT ON Vatandaslar
FOR EACH ROW
BEGIN
    DECLARE s VARCHAR(10);      
    DECLARE toplam INT;        
    DECLARE basamak11 INT;    
    DECLARE basamak10 INT;    
    DECLARE sayi BIGINT;

    DECLARE tekToplam INT;     
    DECLARE ciftToplam INT;    

    -- Eğer id boş gelirse kendisi oluşturur
    IF NEW.id IS NULL OR NEW.id = '' THEN
        SET sayi = 10121719600;
    ELSE
        SET sayi = CAST(NEW.id AS UNSIGNED);
    END IF;

    otomatik_uret:
    LOOP
        SET s = SUBSTRING(CAST(sayi AS CHAR), 1, 10);
        SET s = LPAD(s, 10, '0');

        -- İlk 10 basamağın toplamı
        SET toplam =
              CAST(SUBSTRING(s,1,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,2,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,3,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,4,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,5,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,6,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,7,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,8,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,9,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,10,1) AS UNSIGNED);

        -- Tek basamaklar: 1,3,5,7,9
        SET tekToplam =
              CAST(SUBSTRING(s,1,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,3,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,5,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,7,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,9,1) AS UNSIGNED);

        -- Çift basamaklar: 2,4,6,8
        SET ciftToplam =
              CAST(SUBSTRING(s,2,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,4,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,6,1) AS UNSIGNED) +
              CAST(SUBSTRING(s,8,1) AS UNSIGNED);

        -- herkesin bildiği koşul, ilk 10 hane rakamlar toplamının birler basamağı 11. haneyi vercek
        SET basamak11 = toplam % 10;

        -- 11. basamak çift olmalı
        IF (basamak11 % 2) <> 0 THEN
            SET sayi = sayi + 1;
            ITERATE otomatik_uret;
        END IF;

        -- 1,3,5,7,9 basamaktaki rakamlar toplamının 8 katının birler basamağı tcdeki 11. basamakla aynı olmalı
        IF (tekToplam * 8) % 10 <> basamak11 THEN
            SET sayi = sayi + 1;
            ITERATE otomatik_uret;
        END IF;

	-- 1,3,5,7,9 basamaktaki rakamlar toplamının 7 katından 2,4,6,8 rakamlar toplamını çıkarınca kalanın birler basamağı tcdeki 10. basamağı vercek
        SET basamak10 = ((tekToplam * 7) - ciftToplam) % 10;
        IF basamak10 < 0 THEN
            SET basamak10 = basamak10 + 10;
        END IF;

        -- Tüm id'yi birleştir (10. ve 11. basamak dahil)
        SET NEW.id = CONCAT(SUBSTRING(s,1,9),basamak10,basamak11);

        -- Benzersiz mi?
        IF NOT EXISTS (SELECT 1 FROM Vatandaslar WHERE id = NEW.id) THEN
            LEAVE otomatik_uret;
        END IF;

        SET sayi = sayi + 1;
    END LOOP;
END$$
DELIMITER ;

drop procedure if exists ekle_50_kisi;

DELIMITER $$
CREATE PROCEDURE ekle_50_kisi()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 50 DO
        insert into Vatandaslar (ad, soyad) values (CONCAT('Ad', i), CONCAT('Soyad', i));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL ekle_50_kisi();

insert into vatandaslar (ad, soyad) values ("Osman", "Gültekin");
insert into vatandaslar (ad, soyad) values ("Ahmet", "kömüş");
insert into Vatandaslar (ad, soyad) values ('Aykut', 'Elmas');
insert into Vatandaslar (ad, soyad) values ('Ayşe', 'Demir');
insert into Vatandaslar (ad, soyad) values ('Arda', 'Korkmaz');
SELECT * from Vatandaslar;


SET FOREIGN_KEY_CHECKS = 0;  -- tablo silmeden içindekileri komple sil
TRUNCATE TABLE sifreler;
TRUNCATE TABLE vatandaslar;
SET FOREIGN_KEY_CHECKS = 1;