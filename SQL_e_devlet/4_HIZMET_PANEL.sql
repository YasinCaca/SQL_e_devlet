CREATE TABLE hizmet_kayitlari (
    vatandas_id VARCHAR(11),
    hizmet_adi VARCHAR(50),
    tarih DATETIME DEFAULT NOW(),
    FOREIGN KEY (vatandas_id) REFERENCES vatandaslar(id) ON DELETE CASCADE
);

CREATE TABLE supheli_kullanicilar (
    vatandas_id VARCHAR(11) PRIMARY KEY,
    supheli_tarih DATETIME DEFAULT NOW(),
    FOREIGN KEY (vatandas_id) REFERENCES vatandaslar(id) ON DELETE CASCADE
);

DELIMITER $$
CREATE PROCEDURE hizmet_kullanildi(
    IN p_id VARCHAR(11),
    IN p_hizmet VARCHAR(50)
)
BEGIN
    DECLARE gunluk_kullanim INT;

    -- (1) Kullanıcı şüpheli ise hizmeti kullanamasın
    IF EXISTS (SELECT 1 FROM supheli_kullanicilar WHERE vatandas_id = p_id) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Hizmet engellendi: Kullanıcı şüpheli listesinde.';
    END IF;

    -- (2) Günlük kullanım sayısını hesapla
    SELECT COUNT(*) INTO gunluk_kullanim
    FROM hizmet_kayitlari
    WHERE vatandas_id = p_id
      AND DATE(tarih) = CURDATE();

    -- (3) Limit aşılıyorsa şüpheliye ekle, hizmeti engelle
    IF gunluk_kullanim >= 100 THEN
        INSERT IGNORE INTO supheli_kullanicilar(vatandas_id)
        VALUES (p_id);

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Limit aşımı: Kullanıcı şüpheli olarak işaretlendi.';
    END IF;

    -- (4) Hizmeti kaydet
    INSERT INTO hizmet_kayitlari(vatandas_id, hizmet_adi)
    VALUES (p_id, p_hizmet);

END $$
DELIMITER ;

/*drop event if exists gunluk_kullanim_sifirla;

CREATE EVENT IF NOT EXISTS gunluk_kullanim_sifirla
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY)
DO
    DELETE FROM hizmet_kayitlari;
    */
    
/*    
SELECT COUNT(*) AS gunluk_kullanim
FROM hizmet_kayitlari
WHERE vatandas_id = '12345678901'
  AND DATE(tarih) = CURDATE();  */