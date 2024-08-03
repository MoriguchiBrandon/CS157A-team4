CREATE DATABASE `gamestore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
CREATE TABLE `address` (
  `address_id` int NOT NULL,
  `address` varchar(200) NOT NULL,
  `district` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `postal_code` int NOT NULL,
  `country` varchar(100) NOT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `gamestore` (
  `store_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `manufacturers` (
  `name` varchar(50) NOT NULL,
  `manufactuer_id` int NOT NULL,
  PRIMARY KEY (`manufactuer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `order` (
  `order_id` int NOT NULL,
  `date_ordered` datetime NOT NULL,
  `date_fulfilled` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `platform` (
  `platform_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`platform_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `products` (
  `product_id` int NOT NULL,
  `description` varchar(10000) DEFAULT NULL,
  `price` decimal(6,2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `manf_id` int NOT NULL,
  `platform_id` int NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_manf_id_idx` (`manf_id`),
  KEY `product_platform_id_idx` (`platform_id`),
  CONSTRAINT `product_manf_id` FOREIGN KEY (`manf_id`) REFERENCES `manufacturers` (`manufactuer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `platform` (`platform_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `user` (
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `customer_username_idx` (`username`),
  CONSTRAINT `customer_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `deliver_to` (
  `order_id` int NOT NULL,
  `address_id` int NOT NULL,
  PRIMARY KEY (`order_id`,`address_id`),
  KEY `deliver_address_id_idx` (`address_id`),
  CONSTRAINT `deliver_address_id` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `deliver_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `inventory` (
  `inventory_num` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`inventory_num`),
  KEY `inventory_product_ID_idx` (`product_id`),
  CONSTRAINT `inventory_product_ID` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `orders` (
  `customer_id` int NOT NULL,
  `order_id` int NOT NULL,
  `inventory_num` int NOT NULL,
  PRIMARY KEY (`customer_id`,`inventory_num`,`order_id`),
  KEY `orders_order_id_idx` (`order_id`),
  KEY `orders_inventory_num_idx` (`inventory_num`),
  CONSTRAINT `orders_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `orders_inventory_num` FOREIGN KEY (`inventory_num`) REFERENCES `inventory` (`inventory_num`),
  CONSTRAINT `orders_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `staff_username_idx` (`username`),
  CONSTRAINT `staff_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `works_at` (
  `store_id` int NOT NULL,
  `staff_id` int NOT NULL,
  PRIMARY KEY (`store_id`,`staff_id`),
  KEY `works_at_staff_id_idx` (`staff_id`),
  CONSTRAINT `works_at_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `works_at_store_id` FOREIGN KEY (`store_id`) REFERENCES `gamestore` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `belongs_to` (
  `inventory_id` int NOT NULL,
  `store_id` int NOT NULL,
  PRIMARY KEY (`inventory_id`,`store_id`),
  KEY `belongs_store_id_idx` (`store_id`),
  CONSTRAINT `belongs_inventory_id` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `belongs_store_id` FOREIGN KEY (`store_id`) REFERENCES `gamestore` (`store_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `fulfilled_by` (
  `order_id` int NOT NULL,
  `staff_id` int NOT NULL,
  PRIMARY KEY (`order_id`,`staff_id`),
  KEY `fulfill_staff_id_idx` (`staff_id`),
  CONSTRAINT `fulfill_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fullfill_order_id` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `inventory_add` (
  `inventory_num` int NOT NULL,
  `product_id` int NOT NULL,
  `staff` int NOT NULL,
  PRIMARY KEY (`inventory_num`,`product_id`,`staff`),
  KEY `add_product_id_idx` (`product_id`),
  KEY `add_staff_id_idx` (`staff`),
  CONSTRAINT `add_inventory_id` FOREIGN KEY (`inventory_num`) REFERENCES `inventory` (`inventory_num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `add_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `add_staff_id` FOREIGN KEY (`staff`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `inventory_subtract` (
  `inventory_num` int NOT NULL,
  `product_id` int NOT NULL,
  `staff_id` int NOT NULL,
  PRIMARY KEY (`inventory_num`,`product_id`,`staff_id`),
  KEY `sub_product_id_idx` (`product_id`),
  KEY `sub_staff_id_idx` (`staff_id`),
  CONSTRAINT `sub_inventory_num` FOREIGN KEY (`inventory_num`) REFERENCES `inventory` (`inventory_num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

