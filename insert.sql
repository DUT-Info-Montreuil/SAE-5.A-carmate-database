/* Data test here */
INSERT INTO carmate.user VALUES(1, 'Julien', 'Martineau', 'example1@example.com', sha512('TwKYRF5EtnIOdJH'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(2, 'Millard', 'Morneau', 'user-123@mail-provider.net', sha512('k4RD5ZJTUpoUZw4'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(3, 'Anne', 'Gabriaux', 'john.doe@sub-domain.co', sha512('4ldvJI02YKZQ9v4'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(4, 'Maslin', 'Bélair', 'my_email20@company.org', sha512('Q49I9EErbiPhsw1'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(5, 'Chandler', 'Lanteigne', 'no-reply@place.travel', sha512('EN01Xq17GqOz1vJ'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(6, 'Naulan', 'CHRZASZCZ', 'contact@naulan-chrzaszcz.fr', sha512('admin'::bytea), DEFAULT, DEFAULT);
INSERT INTO carmate.user VALUES(7, 'Tiago', 'NARCISO', 'contact@tiago-narciso.fr', sha512('admin'::bytea), DEFAULT, DEFAULT);

INSERT INTO carmate.carpooling VALUES(1, ARRAY[48.863592, 2.344855], ARRAY[48.882971, 2.369771], DEFAULT, 2.99, DEFAULT, NOW() + '3 days', 3);
INSERT INTO carmate.carpooling VALUES(2, ARRAY[48.845403, 2.310845], ARRAY[48.814155, 2.320484], DEFAULT, 10.0, DEFAULT, NOW() + '60 days', 3);
INSERT INTO carmate.carpooling VALUES(3, ARRAY[48.851985, 2.370135], ARRAY[48.844924, 2.432516], DEFAULT, 0.99, DEFAULT, NOW() + '20 days', 5);
INSERT INTO carmate.carpooling VALUES(4, ARRAY[48.887879, 2.326201], ARRAY[48.797144, 2.390809], DEFAULT, 22.00, DEFAULT, NOW() + '3 days', 5);
INSERT INTO carmate.carpooling VALUES(5, ARRAY[48.868893, 2.389174], ARRAY[48.861184, 2.448033], DEFAULT, 1.50, DEFAULT, NOW() + '1 days', 1);

INSERT INTO carmate.reserve_carpooling VALUES(1, 1, NOW(), 12345, DEFAULT, DEFAULT);

INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '60 minutes', "exemple message 1", DEFAULT, 3, 1);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '120 minutes', "exemple message 2", DEFAULT, 5, 2);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '45 minutes', "exemple message 3", DEFAULT, 5, 2);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '53 minutes', "exemple message 4", DEFAULT, 3, 4);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '100 minutes', "exemple message 5", DEFAULT, 1, 4);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '25 minutes', "exemple message 6", DEFAULT, 5, 6);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '98 minutes', "exemple message 7", DEFAULT, 3, 6);
INSERT INTO carmate.message VALUES(DEFAULT, NOW() - INTERVAL '60 minutes', "exemple message 8", DEFAULT, 5, 7);

INSERT INTO carmate.token VALUES(sha512('VncdCaVOVPp0c3Y0Be1hrJT6qLVLEjcdYjKDP3DbKDw42TwsgFsM6y4s1k5R2JRMs4tghA6BxmJlpCH2MKsPXtEOmOw4KFEAqNFHh247bdD6QPheuZ5qlY5ET2eoarVZ'::bytea), NOW() + INTERVAL '15 minutes', 6);
