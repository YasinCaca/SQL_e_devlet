DELIMITER $$
CREATE PROCEDURE SifreDegis(
    IN v_id VARCHAR(11),
    IN v_eski VARCHAR(100),
    IN v_yeni VARCHAR(100),
    IN v_yeni_tekrar VARCHAR(100),
    OUT sonuc VARCHAR(50)
)
SifreDegis:BEGIN 
    DECLARE db_hash CHAR(64);
    CALL hizmet_kullanildi(v_id, 'SifreDegis');

    SELECT sifre INTO db_hash
    FROM sifreler
    WHERE vatandas_id = v_id;

    IF db_hash IS NULL THEN
        SET sonuc = 'Kullanıcı Bulunamadı';
        LEAVE SifreDegis;
    END IF;

    IF db_hash <> SHA2(v_eski, 256) THEN
        SET sonuc = 'Eski Şifre Yanlış';
        LEAVE SifreDegis;
    END IF;

    IF v_yeni <> v_yeni_tekrar THEN
        SET sonuc = 'Yeni Şifreler Uyuşmuyor';
        LEAVE SifreDegis;
    END IF;

    IF LENGTH(v_yeni) < 12 THEN
        SET sonuc = 'Yeni Şifre En Az 12 Karakter Olmalı';
        LEAVE SifreDegis;
    END IF;

    IF v_yeni NOT REGEXP '[A-Z]' THEN
        SET sonuc = 'Yeni Şifre En Az 1 Büyük Harf İçermeli';
        LEAVE SifreDegis;
    END IF;

    IF v_yeni NOT REGEXP '[a-z]' THEN
        SET sonuc = 'Yeni Şifre En Az 1 Küçük Harf İçermeli';
        LEAVE SifreDegis;
    END IF;

    IF v_yeni NOT REGEXP '[0-9]' THEN
        SET sonuc = 'Yeni Şifre En Az 1 Rakam İçermeli';
        LEAVE SifreDegis;
    END IF;

    IF v_yeni NOT REGEXP '[^A-Za-z0-9]' THEN
        SET sonuc = 'Yeni Şifre En Az 1 Özel Karakter İçermeli';
        LEAVE SifreDegis;
    END IF;

    UPDATE sifreler
    SET sifre = SHA2(v_yeni, 256)
    WHERE vatandas_id = v_id;

    SET sonuc = 'Şifre Değiştirildi';
END $$
DELIMITER ;


delimiter $$
create procedure bruteforcesifre()
begin
DECLARE i INT DEFAULT 1;
WHILE i <= 105 DO
-- SET @sonuc = '';
CALL SifreDegis('10121719620','nL.fAyS7*,yÇ^[','YeniSifre456@','YeniSifre456@', @sonuc);
-- 3) Sonucu görmek için
SET i = i + 1;
END WHILE;
END$$
DELIMITER ;
call bruteforcesifre();

CALL SifreDegis('10121719620','nL.fAyS7*,yÇ^[a','YeniSifre456@','YeniSifre456@', @sonuc);
select @sonuc;