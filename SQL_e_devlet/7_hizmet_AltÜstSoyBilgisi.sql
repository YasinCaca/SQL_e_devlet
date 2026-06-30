CREATE TABLE Soy (
    KisiID VARCHAR(11) NOT NULL PRIMARY KEY,
    AnneID VARCHAR(11),
    BabaID VARCHAR(11),
    FOREIGN KEY (KisiID) REFERENCES Vatandaslar(id),
    FOREIGN KEY (AnneID) REFERENCES Vatandaslar(id),
    FOREIGN KEY (BabaID) REFERENCES Vatandaslar(id)
);

drop procedure if exists soy_sorgula;
DELIMITER $$
CREATE PROCEDURE soy_sorgula(IN p_kisi VARCHAR(11))
BEGIN
    -- Hizmet kullanımını kaydet
    CALL hizmet_kullanildi(p_kisi, 'soy_sorgula');
    -- Tüm yakınlıkları tek sorguda birleştirir
    SELECT * FROM (
        -- Kişi
        SELECT 'Kişi' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Vatandaslar v
        WHERE v.id = p_kisi

        UNION ALL
        -- Anne
        SELECT 'Anne' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s
        JOIN Vatandaslar v ON v.id = s.AnneID
        WHERE s.KisiID = p_kisi

        UNION ALL
        -- Baba
        SELECT 'Baba' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s
        JOIN Vatandaslar v ON v.id = s.BabaID
        WHERE s.KisiID = p_kisi

        UNION ALL
        -- Anneanne
        SELECT 'Anne Tarafı - Anneanne' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s1
        JOIN Soy s2 ON s1.AnneID = s2.KisiID
        JOIN Vatandaslar v ON v.id = s2.AnneID
        WHERE s1.KisiID = p_kisi

        UNION ALL
        -- Anne Tarafı Dede
        SELECT 'Anne Tarafı - Dede' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s1
        JOIN Soy s2 ON s1.AnneID = s2.KisiID
        JOIN Vatandaslar v ON v.id = s2.BabaID
        WHERE s1.KisiID = p_kisi

        UNION ALL
        -- Babaanne
        SELECT 'Baba Tarafı - Babaanne' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s1
        JOIN Soy s2 ON s1.BabaID = s2.KisiID
        JOIN Vatandaslar v ON v.id = s2.AnneID
        WHERE s1.KisiID = p_kisi

        UNION ALL
        -- Baba Tarafı Dede
        SELECT 'Baba Tarafı - Dede' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s1
        JOIN Soy s2 ON s1.BabaID = s2.KisiID
        JOIN Vatandaslar v ON v.id = s2.BabaID
        WHERE s1.KisiID = p_kisi

        UNION ALL
        -- Kardeşler
        SELECT 'Kardeş' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s1
        JOIN Soy s2 ON (
            (s1.AnneID IS NOT NULL AND s1.AnneID = s2.AnneID) OR
            (s1.BabaID IS NOT NULL AND s1.BabaID = s2.BabaID)
        )
        JOIN Vatandaslar v ON v.id = s2.KisiID
        WHERE s1.KisiID = p_kisi
          AND s2.KisiID != p_kisi

        UNION ALL
        -- Çocuklar
        SELECT 'Çocuk' AS Yakınlık, v.id, v.ad, v.soyad
        FROM Soy s
        JOIN Vatandaslar v ON v.id = s.KisiID
        WHERE s.BabaID = p_kisi OR s.AnneID = p_kisi
    ) AS tum_yakinlar
    ORDER BY Yakınlık, id;
END $$
DELIMITER ;


CALL soy_sorgula('12345678901');
-- insert into soy (kisiID, anneID, babaID);