TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER trg_after_inventory_restock\nAFTER INSERT ON inventory_logs\nFOR EACH ROW\nBEGIN\n    IF NEW.change_type = \'restock\' THEN\n        UPDATE products\n        SET stock = stock + NEW.quantity\n        WHERE id = NEW.product_id;\n    END IF;\nEND'
sql_modes=1098907648
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci'
created=1761626766253271
