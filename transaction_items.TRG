TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER trg_after_transaction_item_insert\nAFTER INSERT ON transaction_items\nFOR EACH ROW\nBEGIN\n    -- Decrease stock in products\n    UPDATE products\n    SET stock = stock - NEW.quantity\n    WHERE id = NEW.product_id;\n\n    -- Log the sale in inventory_logs\n    INSERT INTO inventory_logs (product_id, user_id, change_type, quantity, remarks)\n    VALUES (\n        NEW.product_id,\n        (SELECT user_id FROM transactions WHERE id = NEW.transaction_id),\n        \'sale\',\n        NEW.quantity,\n        CONCAT(\'Auto log: sold \', NEW.quantity, \' unit(s)\')\n    );\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER trg_after_transaction_item_delete\nAFTER DELETE ON transaction_items\nFOR EACH ROW\nBEGIN\n    -- Restore stock\n    UPDATE products\n    SET stock = stock + OLD.quantity\n    WHERE id = OLD.product_id;\n\n    -- Log the reversal\n    INSERT INTO inventory_logs (product_id, user_id, change_type, quantity, remarks)\n    VALUES (\n        OLD.product_id,\n        (SELECT user_id FROM transactions WHERE id = OLD.transaction_id),\n        \'adjustment\',\n        OLD.quantity,\n        \'Auto log: transaction item deleted, stock restored\'\n    );\nEND'
sql_modes=1098907648 1098907648
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_unicode_ci' 'utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
created=1761626765963343 1761626766142551
