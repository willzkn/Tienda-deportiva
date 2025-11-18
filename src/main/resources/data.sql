-- Categorías de ejemplo
-- =====================================================
-- INSERCIONES PARA CATEGORIAS (10 categorías deportivas)
-- =====================================================

INSERT INTO Categorias (nombre_categoria) VALUES
('Calzado Deportivo'),
('Ropa Deportiva Hombre'),
('Ropa Deportiva Mujer'),
('Ropa Deportiva Niños'),
('Fútbol'),
('Basketball'),
('Volleyball'),
('Tenis'),
('Running'),
('Fitness y Gym');

-- =====================================================
-- INSERCIONES PARA PRODUCTOS (100 registros)
-- =====================================================

INSERT INTO Productos (sku, nombre, id_categoria, precio, stock) VALUES
-- Calzado Deportivo (10 productos)
('ZAP-001', 'Zapatillas Nike Air Max Running', 1, 299.90, 45),
('ZAP-002', 'Zapatillas Adidas Ultraboost', 1, 349.90, 32),
('ZAP-003', 'Zapatillas Puma Running Velocity', 1, 189.90, 58),
('ZAP-004', 'Zapatillas Reebok CrossFit', 1, 259.90, 28),
('ZAP-005', 'Zapatillas New Balance 574', 1, 279.90, 41),
('ZAP-006', 'Zapatillas Nike Court Basketball', 1, 329.90, 25),
('ZAP-007', 'Zapatillas Adidas Predator Fútbol', 1, 399.90, 19),
('ZAP-008', 'Zapatillas Asics Gel Running', 1, 319.90, 36),
('ZAP-009', 'Zapatillas Converse All Star', 1, 159.90, 67),
('ZAP-010', 'Zapatillas Under Armour Training', 1, 289.90, 44),

-- Ropa Deportiva Hombre (10 productos)
('RDH-001', 'Polo Deportivo Nike Dri-Fit Hombre', 2, 89.90, 120),
('RDH-002', 'Short Adidas Running Hombre', 2, 79.90, 95),
('RDH-003', 'Pantalón Jogger Puma Hombre', 2, 129.90, 73),
('RDH-004', 'Casaca Cortaviento Nike Hombre', 2, 199.90, 48),
('RDH-005', 'Polo Under Armour Compression Hombre', 2, 99.90, 82),
('RDH-006', 'Short Basketball Jordan Hombre', 2, 119.90, 56),
('RDH-007', 'Conjunto Deportivo Adidas Hombre', 2, 249.90, 38),
('RDH-008', 'Buzo Reebok Training Hombre', 2, 179.90, 64),
('RDH-009', 'Licra Running Nike Hombre', 2, 109.90, 71),
('RDH-010', 'Chompa Fleece Puma Hombre', 2, 159.90, 52),

-- Ropa Deportiva Mujer (10 productos)
('RDM-001', 'Top Deportivo Nike Pro Mujer', 3, 79.90, 145),
('RDM-002', 'Calza Adidas Running Mujer', 3, 99.90, 128),
('RDM-003', 'Short Puma Training Mujer', 3, 69.90, 98),
('RDM-004', 'Conjunto Yoga Reebok Mujer', 3, 189.90, 62),
('RDM-005', 'Casaca Running Nike Mujer', 3, 179.90, 54),
('RDM-006', 'Calza Larga Under Armour Mujer', 3, 119.90, 87),
('RDM-007', 'Top Deportivo Adidas Mujer', 3, 89.90, 103),
('RDM-008', 'Buzo Completo Nike Mujer', 3, 229.90, 41),
('RDM-009', 'Short Ciclista Puma Mujer', 3, 59.90, 115),
('RDM-010', 'Polo Deportivo Reebok Mujer', 3, 69.90, 134),

-- Ropa Deportiva Niños (10 productos)
('RDN-001', 'Polo Nike Kids Running', 4, 49.90, 156),
('RDN-002', 'Short Adidas Kids Fútbol', 4, 45.90, 142),
('RDN-003', 'Conjunto Puma Kids Training', 4, 119.90, 78),
('RDN-004', 'Buzo Nike Kids Basketball', 4, 139.90, 64),
('RDN-005', 'Calza Adidas Kids', 4, 59.90, 98),
('RDN-006', 'Casaca Reebok Kids', 4, 99.90, 72),
('RDN-007', 'Polo Under Armour Kids', 4, 54.90, 125),
('RDN-008', 'Pantalón Deportivo Nike Kids', 4, 79.90, 89),
('RDN-009', 'Short Puma Kids Basketball', 4, 49.90, 137),
('RDN-010', 'Conjunto Adidas Kids Running', 4, 129.90, 55),

-- Fútbol (10 productos)
('FUT-001', 'Balón Fútbol Nike Premier League', 5, 149.90, 87),
('FUT-002', 'Guantes Portero Adidas Predator', 5, 179.90, 34),
('FUT-003', 'Canilleras Nike Mercurial', 5, 49.90, 165),
('FUT-004', 'Camiseta Selección Perú 2024', 5, 199.90, 234),
('FUT-005', 'Balón Adidas Champions League', 5, 169.90, 76),
('FUT-006', 'Medias Fútbol Puma Pro', 5, 29.90, 298),
('FUT-007', 'Short Fútbol Nike Dri-Fit', 5, 69.90, 143),
('FUT-008', 'Bolso Deportivo Adidas Fútbol', 5, 129.90, 54),
('FUT-009', 'Conos Entrenamiento Set x12', 5, 39.90, 89),
('FUT-010', 'Red Arco Fútbol Profesional', 5, 299.90, 23),

-- Basketball (10 productos)
('BAS-001', 'Balón Basketball Spalding NBA', 6, 179.90, 67),
('BAS-002', 'Aro Basketball Profesional', 6, 899.90, 12),
('BAS-003', 'Camiseta NBA Lakers', 6, 189.90, 145),
('BAS-004', 'Short Basketball Nike Elite', 6, 99.90, 89),
('BAS-005', 'Medias Basketball Jordan', 6, 39.90, 234),
('BAS-006', 'Rodilleras Basketball McDavid', 6, 79.90, 112),
('BAS-007', 'Balón Basketball Wilson', 6, 149.90, 73),
('BAS-008', 'Muñequeras Nike Basketball', 6, 29.90, 187),
('BAS-009', 'Bolso Basketball Under Armour', 6, 139.90, 56),
('BAS-010', 'Camiseta Basketball Reversible', 6, 79.90, 98),

-- Volleyball (10 productos)
('VOL-001', 'Balón Volleyball Mikasa MVA200', 7, 189.90, 54),
('VOL-002', 'Rodilleras Volleyball Mizuno', 7, 69.90, 123),
('VOL-003', 'Zapatillas Asics Volleyball', 7, 329.90, 34),
('VOL-004', 'Red Volleyball Profesional', 7, 449.90, 18),
('VOL-005', 'Camiseta Volleyball Mizuno', 7, 89.90, 87),
('VOL-006', 'Short Volleyball Adidas', 7, 59.90, 145),
('VOL-007', 'Medias Volleyball Nike', 7, 34.90, 198),
('VOL-008', 'Bolso Volleyball Mikasa', 7, 119.90, 43),
('VOL-009', 'Balón Volleyball Wilson', 7, 159.90, 67),
('VOL-010', 'Coderas Volleyball Mueller', 7, 49.90, 89),

-- Tenis (10 productos)
('TEN-001', 'Raqueta Tenis Wilson Pro Staff', 8, 899.90, 23),
('TEN-002', 'Pelotas Tenis Wilson Pack x3', 8, 29.90, 234),
('TEN-003', 'Zapatillas Tenis Nike Court', 8, 349.90, 45),
('TEN-004', 'Bolso Raquetero Head', 8, 199.90, 34),
('TEN-005', 'Raqueta Tenis Head Graphene', 8, 799.90, 18),
('TEN-006', 'Grip Tenis Wilson Pack x3', 8, 24.90, 156),
('TEN-007', 'Polo Tenis Adidas', 8, 89.90, 78),
('TEN-008', 'Short Tenis Nike', 8, 79.90, 92),
('TEN-009', 'Muñequera Tenis Nike', 8, 19.90, 267),
('TEN-010', 'Cuerda Raqueta Luxilon', 8, 89.90, 67),

-- Running (10 productos)
('RUN-001', 'Reloj GPS Garmin Forerunner', 9, 1299.90, 28),
('RUN-002', 'Brazalete Porta Celular Running', 9, 39.90, 187),
('RUN-003', 'Hidratación Running Nike', 9, 79.90, 112),
('RUN-004', 'Gorra Running Adidas', 9, 49.90, 156),
('RUN-005', 'Lentes Running Oakley', 9, 299.90, 45),
('RUN-006', 'Cinturón Hidratación Salomon', 9, 149.90, 67),
('RUN-007', 'Chaleco Reflectivo Running', 9, 59.90, 98),
('RUN-008', 'Calcetines Running Stance', 9, 34.90, 234),
('RUN-009', 'Buff Running Multiuso', 9, 39.90, 178),
('RUN-010', 'Riñonera Running Nike', 9, 69.90, 123),

-- Fitness y Gym (10 productos)
('FIT-001', 'Mancuernas Ajustables 20kg Par', 10, 399.90, 34),
('FIT-002', 'Colchoneta Yoga Mat 6mm', 10, 79.90, 145),
('FIT-003', 'Banda Elástica Resistencia Set x5', 10, 49.90, 198),
('FIT-004', 'Guantes Gym Nike Training', 10, 59.90, 112),
('FIT-005', 'Pelota Pilates 65cm', 10, 69.90, 87),
('FIT-006', 'Disco Peso 10kg', 10, 159.90, 56),
('FIT-007', 'Barra Dominadas Pared', 10, 129.90, 43),
('FIT-008', 'Soga Saltar Crossfit', 10, 39.90, 234),
('FIT-009', 'Rueda Abdominal Pro', 10, 49.90, 167),
('FIT-010', 'Kettlebell 12kg', 10, 179.90, 67);

-- =====================================================
-- INSERCIONES PARA USUARIOS ADMIN (Usuario de ejemplo)
-- =====================================================
INSERT INTO UsuarioAdmin (correo, clave, rol) VALUES
('admin@ventadepor.com', '1234admin', 'Admin'),
('cliente1@example.com', 'pass123', 'Cliente'),
('cliente2@example.com', 'pass456', 'Cliente');

-- =====================================================
-- INSERCIONES PARA BOLETAS (usando id_usuario = 1 para admin)
-- =====================================================
INSERT INTO Boletas (id_usuario, fecha_emision, total) VALUES
  (1, '2025-06-15 10:30:00', 599.80),
  (1, '2025-06-16 14:20:00', 349.90),
  (1, '2025-06-29 10:50:00', 989.80),
  (1, '2025-07-17 09:15:00', 1249.70),
  (1, '2025-07-30 15:10:00', 1299.90),
  (1, '2025-08-18 16:45:00', 429.80),
  (1, '2025-08-31 12:25:00', 579.80),
  (1, '2025-09-01 14:40:00', 849.70),
  (1, '2025-09-02 09:55:00', 399.90),
  (1, '2025-09-19 11:30:00', 789.70),
  (1, '2025-10-03 16:30:00', 1499.80),
  (1, '2025-10-20 13:50:00', 299.90),
  (1, '2025-11-21 15:20:00', 1599.80),
  (1, '2025-12-22 10:10:00', 549.80),
  (1, '2025-12-23 12:40:00', 899.80),
  (1, '2025-12-24 14:15:00', 379.80),
  (1, '2025-12-25 09:30:00', 649.80),
  (1, '2025-12-26 16:20:00', 1099.90),
  (1, '2025-12-27 11:45:00', 729.80);

INSERT INTO Boletas (id_usuario, fecha_emision, total) VALUES
  (2, '2025-06-18 11:15:00', 219.90),
  (2, '2025-06-22 16:05:00', 459.80),
  (2, '2025-06-27 09:45:00', 749.50),
  (2, '2025-07-02 13:20:00', 329.90),
  (2, '2025-07-05 10:10:00', 289.90),
  (2, '2025-07-12 18:40:00', 999.80),
  (2, '2025-07-20 08:55:00', 579.70),
  (2, '2025-07-28 17:35:00', 1299.90),
  (2, '2025-08-02 12:00:00', 199.90),
  (2, '2025-08-07 15:25:00', 429.80),
  (2, '2025-08-12 09:10:00', 309.90),
  (2, '2025-08-20 19:05:00', 899.90),
  (2, '2025-08-25 07:50:00', 149.90),
  (3, '2025-09-05 10:30:00', 669.80),
  (3, '2025-09-10 14:45:00', 379.80),
  (3, '2025-09-15 16:20:00', 819.70),
  (3, '2025-09-22 11:05:00', 499.90),
  (3, '2025-09-28 18:15:00', 1399.80),
  (3, '2025-10-05 09:25:00', 259.90),
  (3, '2025-10-10 13:55:00', 349.90),
  (3, '2025-10-15 16:40:00', 929.80),
  (3, '2025-10-22 08:30:00', 299.90),
  (3, '2025-10-28 17:10:00', 1099.90),
  (1, '2025-11-05 10:05:00', 599.80),
  (1, '2025-11-10 15:50:00', 449.90),
  (1, '2025-11-15 12:35:00', 749.80),
  (1, '2025-11-25 18:25:00', 1599.80),
  (1, '2025-12-05 09:40:00', 539.80),
  (1, '2025-12-10 14:15:00', 889.90),
  (1, '2025-12-20 16:55:00', 1049.70),
  (1, '2025-07-22 11:35:00', 699.90);

INSERT INTO Detalle_Boleta (id_boleta, id_producto, cantidad, precio_unitario) VALUES
  -- Boleta 1
  (1, 1, 1, 299.90),   -- ZAP-001
  (1, 2, 1, 349.90),   -- ZAP-002
  -- Boleta 2
  (2, 11, 2, 89.90),   -- RDH-001
  (2, 12, 1, 79.90),   -- RDH-002
  -- Boleta 3
  (3, 21, 1, 79.90),   -- RDM-001
  (3, 22, 2, 99.90),   -- RDM-002
  -- Boleta 4
  (4, 31, 1, 49.90),   -- RDN-001
  (4, 32, 1, 45.90),   -- RDN-2
  -- Boleta 5
  (5, 41, 1, 149.90),  -- FUT-001
  (5, 42, 1, 179.90),  -- FUT-002
  -- Boleta 6
  (6, 51, 1, 179.90),  -- BAS-001
  (6, 52, 1, 899.90),  -- BAS-002
  -- Boleta 7
  (7, 61, 1, 189.90),  -- VOL-001
  (7, 62, 2, 69.90),   -- VOL-002
  -- Boleta 8
  (8, 71, 1, 899.90),  -- TEN-001
  (8, 72, 3, 29.90),   -- TEN-002
  -- Boleta 9
  (9, 81, 1, 1299.90), -- RUN-001
  (9, 86, 1, 149.90),  -- RUN-006
  -- Boleta 10
  (10, 91, 1, 399.90), -- FIT-001
  (10, 98, 2, 39.90);  -- FIT-008


INSERT INTO Detalle_Boleta (id_boleta, id_producto, cantidad, precio_unitario) VALUES
  -- Boleta 11 -> map to 1
  (1, 3, 1, 189.90),   -- ZAP-003
  (1, 8, 1, 319.90),   -- ZAP-008
  -- Boleta 12 -> map to 2
  (2, 13, 2, 129.90),  -- RDH-003
  (2, 16, 1, 119.90),  -- RDH-006
  -- Boleta 13 -> map to 3
  (3, 21, 1, 79.90),   -- RDM-001
  (3, 25, 1, 179.90),  -- RDM-005
  -- Boleta 14 -> map to 4
  (4, 31, 1, 49.90),   -- RDN-001
  (4, 34, 1, 139.90),  -- RDN-004
  -- Boleta 15 -> map to 5
  (5, 41, 1, 149.90),  -- FUT-001
  (5, 45, 1, 169.90),  -- FUT-005
  -- Boleta 16 -> map to 6
  (6, 51, 1, 179.90),  -- BAS-001
  (6, 55, 2, 39.90),   -- BAS-005
  -- Boleta 17 -> map to 7
  (7, 61, 1, 189.90),  -- VOL-001
  (7, 66, 2, 59.90),   -- VOL-006
  -- Boleta 18 -> map to 8
  (8, 71, 1, 899.90),  -- TEN-001
  (8, 73, 1, 349.90),  -- TEN-003
  -- Boleta 19 -> map to 9
  (9, 81, 1, 1299.90), -- RUN-001
  (9, 85, 1, 299.90),  -- RUN-005
  -- Boleta 20 -> map to 10
  (10, 91, 1, 399.90);  -- FIT-001


INSERT INTO Detalle_Boleta (id_boleta, id_producto, cantidad, precio_unitario) VALUES
  -- Boleta 21
  (21, 3, 1, 189.90),
  (21, 7, 2, 159.90),
  -- Boleta 22
  (22, 12, 1, 79.90),
  (22, 18, 1, 119.90),
  -- Boleta 23
  (23, 25, 1, 179.90),
  (23, 29, 1, 159.90),
  -- Boleta 24
  (24, 33, 2, 49.90),
  (24, 36, 1, 99.90),
  -- Boleta 25
  (25, 41, 1, 149.90),
  (25, 46, 1, 69.90),
  -- Boleta 26
  (26, 52, 1, 899.90),
  (26, 51, 1, 179.90),
  -- Boleta 27
  (27, 61, 1, 189.90),
  (27, 66, 2, 59.90),
  -- Boleta 28
  (28, 71, 1, 899.90),
  (28, 73, 1, 349.90),
  -- Boleta 29
  (29, 82, 1, 169.90),
  (29, 86, 1, 149.90),
  -- Boleta 30
  (30, 91, 1, 399.90),
  (30, 98, 2, 39.90),
  -- Boleta 31
  (31, 4, 1, 259.90),
  (31, 10, 1, 289.90),
  -- Boleta 32
  (32, 15, 2, 79.90),
  (32, 19, 1, 169.90),
  -- Boleta 33
  (33, 22, 1, 99.90),
  (33, 28, 1, 119.90),
  -- Boleta 34
  (34, 31, 1, 49.90),
  (34, 39, 1, 159.90),
  -- Boleta 35
  (35, 44, 1, 79.90),
  (35, 47, 1, 119.90),
  -- Boleta 36
  (36, 53, 1, 129.90),
  (36, 56, 1, 39.90),
  -- Boleta 37
  (37, 63, 1, 189.90),
  (37, 68, 2, 59.90),
  -- Boleta 38
  (38, 72, 3, 29.90),
  (38, 74, 1, 349.90),
  -- Boleta 39
  (39, 81, 1, 1299.90),
  (39, 83, 1, 169.90),
  -- Boleta 40
  (40, 92, 1, 899.90),
  (40, 97, 2, 39.90),
  -- Boleta 41
  (41, 6, 1, 329.90),
  (41, 9, 1, 159.90),
  -- Boleta 42
  (42, 13, 2, 129.90),
  (42, 17, 1, 119.90),
  -- Boleta 43
  (43, 21, 1, 79.90),
  (43, 26, 1, 259.90),
  -- Boleta 44
  (44, 32, 1, 45.90),
  (44, 38, 1, 179.90),
  -- Boleta 45
  (45, 45, 1, 169.90),
  (45, 49, 1, 299.90),
  -- Boleta 46
  (46, 54, 1, 119.90),
  (46, 59, 1, 109.90),
  -- Boleta 47
  (47, 64, 1, 89.90),
  (47, 67, 2, 34.90),
  -- Boleta 48
  (48, 75, 1, 79.90),
  (48, 79, 1, 39.90),
  -- Boleta 49
  (49, 84, 1, 79.90),
  (49, 88, 1, 299.90),
  -- Boleta 50
  (50, 93, 1, 149.90),
  (50, 99, 2, 39.90);