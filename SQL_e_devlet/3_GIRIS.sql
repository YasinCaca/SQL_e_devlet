DELIMITER $$
CREATE PROCEDURE giris(
    IN v_id VARCHAR(11),
    IN v_sifre VARCHAR(50),
    OUT sonuc VARCHAR(20)
)
BEGIN
    DECLARE db_hash CHAR(64);

    -- Kullanıcının hash'lenmiş şifresini al
    SELECT sifre INTO db_hash
    FROM sifreler
    WHERE vatandas_id = v_id;

    -- Kayıt yoksa veya şifre yanlışsa
    IF db_hash IS NULL OR db_hash <> SHA2(v_sifre, 256) THEN
        SET sonuc = 'Giriş Başarısız';
    ELSE
        -- Şifre doğruysa
        SET sonuc = 'Giriş Başarılı';
        -- Giriş hizmetini kaydet
		CALL hizmet_kullanildi(v_id, 'giris');
    END IF;
END $$
DELIMITER ;

CALL giris('10121719620', 'nL.fAyS7*,yÇ^[a', @sonuc);
SELECT @sonuc;