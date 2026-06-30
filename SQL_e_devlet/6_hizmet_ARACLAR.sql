CREATE TABLE Arac (
    plaka VARCHAR(20) NOT NULL PRIMARY KEY,
    marka VARCHAR(50),
    model VARCHAR(50)
);

-- yeahh %300 ötv
CREATE TABLE KayitliArac (
    plaka VARCHAR(20) NOT NULL,
    vatandas_id VARCHAR(11) NOT NULL,
    FOREIGN KEY (plaka) REFERENCES Arac(plaka) ON DELETE CASCADE,
    FOREIGN KEY (vatandas_id) REFERENCES Vatandaslar(id) ON DELETE CASCADE,
    PRIMARY KEY (plaka, vatandas_id)  -- Aynı kişi aynı plakayı sadece bir kez kaydedebilir
);

-- Prosedür: bir kişiye ait tüm araçları listeler
DELIMITER $$
CREATE PROCEDURE kisi_araclarini_listele(IN p_id VARCHAR(11))
BEGIN
    -- Hizmet kullanımını kaydet
    CALL hizmet_kullanildi(p_id, 'kisi_araclarini_listele');

    SELECT a.plaka, a.marka, a.model
    FROM KayitliArac ka
    JOIN Arac a ON a.plaka = ka.plaka
    WHERE ka.vatandas_id = p_id
    ORDER BY a.marka, a.model;
END $$
DELIMITER ;

-- call kisi_araclarini_listele('12345678901');
-- insert into arac (plaka, marka, model);
-- insert into kayitliarac(kisiID, plaka);