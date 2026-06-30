drop table if exists sifreler;
CREATE TABLE sifreler (
    vatandas_id VARCHAR(11) PRIMARY KEY,   -- Aynı anda hem Primary hem Foreign
    sifre CHAR(64),                        -- SHA256 Hash
    FOREIGN KEY (vatandas_id) REFERENCES Vatandaslar(id) on delete cascade
);

drop table if exists ilk_sifre;
CREATE TABLE ilk_sifre (
    vatandas_id VARCHAR(11) PRIMARY KEY,   -- Aynı anda hem Primary hem Foreign
    ilksifre CHAR(17),                        -- ptt'den git al
    FOREIGN KEY (vatandas_id) REFERENCES Vatandaslar(id) on delete cascade
);


drop function if exists rastgele_sifre;

DELIMITER $$
CREATE FUNCTION rastgele_sifre()
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE uzunluk INT;
    DECLARE chars VARCHAR(200);
    DECLARE sifre VARCHAR(20) DEFAULT '';
    DECLARE i INT DEFAULT 1;

    SET uzunluk = FLOOR(12 + (RAND() * 5));  -- 12-16
    SET chars = 'abcçdefgğhıijklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ0123456789.:,;-_*?="!^+%&/()>#${[]}~';

    WHILE i <= uzunluk DO
        SET sifre = CONCAT(
            sifre,
            SUBSTRING(chars, FLOOR(1 + RAND() * LENGTH(chars)), 1)
        );
        SET i = i + 1;
    END WHILE;
    RETURN sifre;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS sifreyi_kes;

DELIMITER $$
CREATE TRIGGER sifreyi_kes
AFTER INSERT ON vatandaslar
FOR EACH ROW
BEGIN
    DECLARE plain VARCHAR(16);

    -- Normal şifreyi üret
    SET plain = rastgele_sifre();

    -- Hash'i kaydet
    INSERT INTO sifreler (vatandas_id, sifre)
    VALUES (NEW.id, SHA2(plain, 256));
    insert into ilk_sifre (vatandas_id, ilksifre) values (new.id, plain);
END$$
DELIMITER ;

-- INSERT INTO sifreler (vatandas_id, sifre) VALUES (LAST_INSERT_ID(), "12345");

SELECT v.id, v.ad, v.soyad, i.ilksifre, s.sifre
FROM vatandaslar v
LEFT JOIN ilk_sifre i ON i.vatandas_id = v.id left join sifreler s ON s.vatandas_id = v.id;