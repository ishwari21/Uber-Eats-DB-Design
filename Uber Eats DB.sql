CREATE SCHEMA UBEREATS;
USE UBEREATS;

CREATE TABLE PERSON (
	Phone_num VARCHAR(15),
    Email 	  VARCHAR(255) NOT NULL, 
	Fname     VARCHAR(15)  NOT NULL, 
	Lname     VARCHAR(15)  NOT NULL,
    PRIMARY KEY (Phone_num),
    UNIQUE (Email)
);

CREATE TABLE EMPLOYEE (
	Phone_num VARCHAR(15),
    Ssn 	  CHAR(9) NOT NULL,
    PRIMARY KEY (Phone_num),
    UNIQUE (Ssn),
    FOREIGN KEY (Phone_num) REFERENCES PERSON(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE CUSTOMER (
	Phone_num 	 VARCHAR(15),
    Addr 	  	 VARCHAR(50) NOT NULL,
    Passwrd  	 VARCHAR(50) NOT NULL,
    UberOne_flag BIT(1) 	 NOT NULL DEFAULT 0,
    PRIMARY KEY (Phone_num),
    FOREIGN KEY (Phone_num) REFERENCES PERSON(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE DELIVERY_DRIVER (
	Phone_num	  VARCHAR(15),
    ID_num		  VARCHAR(15) NOT NULL,
	Age			  INTEGER 	  NOT NULL,
    Bank_acct_num VARCHAR(12) NOT NULL,
    PRIMARY KEY (Phone_num),
    UNIQUE (ID_num),
    FOREIGN KEY (Phone_num) REFERENCES EMPLOYEE(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE DRIVER_EARNINGS (
    Order_num			 INTEGER AUTO_INCREMENT,
    Per_mile_rate	     DECIMAL(4,2),
    Miles_driven		 DECIMAL(4,1),
    Pickup_earnings	 	 DECIMAL(4,2),
    Dropoff_earnings	 DECIMAL(4,2),
    Ctip				 DECIMAL(4,2) DEFAULT 0,
    PRIMARY KEY (Order_num)
);

CREATE TABLE DRIVER_ORDERS (
	Phone_num	VARCHAR(15),
    Order_num	INTEGER AUTO_INCREMENT,
    PRIMARY KEY (Phone_num, Order_num),
    FOREIGN KEY (Phone_num) REFERENCES DELIVERY_DRIVER(Phone_num)
				 ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Order_num) REFERENCES DRIVER_EARNINGS(Order_num)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE APP_DESIGNER (
	Phone_num	VARCHAR(15),
    Salary		DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Phone_num),
    FOREIGN KEY (Phone_num) REFERENCES EMPLOYEE(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE RESTAURANT (
	Addr			VARCHAR(50),
	Phone_num		VARCHAR(15)  NOT NULL,
	Restaurant_name	VARCHAR(25)  NOT NULL,
    Rating			DECIMAL(2,1) NOT NULL,
    Has_delivery	BIT(1) 		 NOT NULL DEFAULT 1,
    Has_Pickup		BIT(1) 		 NOT NULL DEFAULT 0,
    PRIMARY KEY (Addr),
    UNIQUE (Phone_num),
    CONSTRAINT chk_Ratings CHECK (Rating >= 0 AND Rating <= 5)
);

CREATE TABLE RESTAURANT_HOURS (
	Day_of_week 	VARCHAR(15),
	Open_time 		TIME,
	Close_time 		TIME,
	Restaurant_addr	VARCHAR(50),
    PRIMARY KEY (Day_of_week, Open_time, Close_time, Restaurant_addr),
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RESTAURANT_CATEGORY (
	Category		VARCHAR(15),
    Restaurant_addr	VARCHAR(50),
    PRIMARY KEY (Category, Restaurant_addr),
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RESTAURANT_DEALS (
	Deal_ID			VARCHAR(15),
    Restaurant_addr	VARCHAR(50),
    PRIMARY KEY (Deal_ID, Restaurant_addr),
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RESTAURANT_MENU (
	Item_name	VARCHAR(15),
    Item_descr	VARCHAR(50),
    Item_cost	DECIMAL(5,2),
    Restaurant_addr	VARCHAR(50),
    PRIMARY KEY (Item_name, Item_descr, Item_cost, Restaurant_addr),
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BROWSES (
	Restaurant_addr		VARCHAR(50),
    Customer_phone_num 	VARCHAR(15),
    Search_history		VARCHAR(50),
    PRIMARY KEY (Restaurant_addr, Customer_phone_num),
    FOREIGN KEY (Customer_phone_num) REFERENCES CUSTOMER(Phone_num)
				 ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE CART (
	Cart_ID				INTEGER AUTO_INCREMENT,
    Customer_phone_num 	VARCHAR(15) NOT NULL,
    PRIMARY KEY (Cart_ID),
    FOREIGN KEY (Customer_phone_num) REFERENCES CUSTOMER(Phone_num)
				 ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE CART_ITEMS (
	Cart_ID			INTEGER AUTO_INCREMENT,
	Item_quantity	INTEGER DEFAULT 0,
	Item_name		VARCHAR(15),
    Item_cost		DECIMAL(5,2),
    PRIMARY KEY (Cart_ID, Item_quantity, Item_name, Item_cost),
    FOREIGN KEY (Cart_ID) REFERENCES CART(Cart_ID)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ORDER_PAYMENT (
    Order_num	INTEGER AUTO_INCREMENT,
    Card_num	VARCHAR(19),
    Order_date	DATE NOT NULL,
    Order_time	TIME NOT NULL,
    PRIMARY KEY (Order_num, Card_num)
);

CREATE TABLE PAYMENT (
	Card_num	  VARCHAR(19),
    Card_name	  VARCHAR(31) NOT NULL,
    Expiry_date	  DATE NOT NULL,
    Security_code VARCHAR(4) NOT NULL,
    PRIMARY KEY (Card_num)
);

CREATE TABLE ORDER_INFO (
    Order_num			INTEGER AUTO_INCREMENT,
    Cancel_fee  		DECIMAL(4,2) DEFAULT 0,
    Tax					DECIMAL(4,2) NOT NULL,
    Delivery_fee 		DECIMAL(4,2) NOT NULL,
    Delivery_time 		TIME 		 NOT NULL,
    Delivery_address 	VARCHAR(50)  NOT NULL,
    Cart_ID				INTEGER      NOT NULL,
    Driver_phone_num 	VARCHAR(15)  NOT NULL,
    Customer_phone_num	VARCHAR(15)  NOT NULL,	
    Time_accepted		TIME 		 NOT NULL,
    Time_started		TIME 		 NOT NULL,
    Time_almost_ready	TIME 		 NOT NULL,
    Time_ready			TIME 		 NOT NULL,	 
    Driver_loc			VARCHAR(50)  NOT NULL,	
    Restaurant_addr		VARCHAR(50)  NOT NULL,
    Total_cost			DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (Order_num),
    FOREIGN KEY (Cart_ID) REFERENCES CART(Cart_ID)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Driver_phone_num) REFERENCES DELIVERY_DRIVER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Customer_phone_num) REFERENCES CUSTOMER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE TRANSPORTATION_METHOD (
	Registration_no 		 INTEGER AUTO_INCREMENT,
    Speed 					 INTEGER,
    Car_license_plate_no 	 VARCHAR(7),
    Scooter_license_plate_no VARCHAR(7),
    Car_flag 				 BIT(1) DEFAULT 0,
    Scooter_flag 			 BIT(1) DEFAULT 0,
    Bike_flag 				 BIT(1) DEFAULT 0,
    Foot_flag 				 BIT(1) DEFAULT 0,
    PRIMARY KEY (Registration_no)
);

CREATE TABLE CAR (
	Car_license_plate_no VARCHAR(7),
    Car_make 			 VARCHAR(10) NOT NULL,
    Car_model 			 VARCHAR(10) NOT NULL,
    Car_color 			 VARCHAR(10) NOT NULL, 
    Car_year 			 VARCHAR(4)  NOT NULL,
    Car_num_doors  		 CHAR(1) 	 NOT NULL,
    PRIMARY KEY (Car_license_plate_no)
);

CREATE TABLE SCOOTER (
	Scooter_license_plate_no VARCHAR(7),
    Scooter_make  			 VARCHAR(10) NOT NULL,
    Scooter_model 			 VARCHAR(10) NOT NULL,
    Scooter_color 			 VARCHAR(10) NOT NULL,
    Scooter_year 			 VARCHAR(4) NOT NULL,
    Scooter_cc 				 CHAR(3) NOT NULL,
    PRIMARY KEY (Scooter_license_plate_no)
);

CREATE TABLE REGISTERS (
	Driver_phone_num	VARCHAR(15),
    Registration_no		INTEGER AUTO_INCREMENT,
    PRIMARY KEY (Driver_phone_num, Registration_no),
	FOREIGN KEY (Driver_phone_num) REFERENCES DELIVERY_DRIVER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Registration_no) REFERENCES TRANSPORTATION_METHOD(Registration_no)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE REQUEST (
	Request_ID 		INTEGER AUTO_INCREMENT,
    Driver_loc 		VARCHAR(50) NOT NULL,
    Restaurant_addr VARCHAR(50) NOT NULL,
    Customer_addr	VARCHAR(50) NOT NULL,
    PRIMARY KEY (Request_ID)
);

CREATE TABLE REQUEST_DETAILS_FOR_DRIVER (
    Driver_loc		     VARCHAR(50),
    Restaurant_addr 	 VARCHAR(50),
    Customer_addr    	 VARCHAR(50),
    Total_delivery_miles DECIMAL(4,1) NOT NULL,
    Total_delivery_time  VARCHAR(15)  NOT NULL,
    Payment_minus_Ctip	 DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (Driver_loc, Restaurant_addr, Customer_addr)
);

CREATE TABLE RECEIVES (
	Driver_phone_num	VARCHAR(15),
    Request_ID 			INTEGER AUTO_INCREMENT,
    Is_driver_online	BIT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (Driver_phone_num, Request_ID),
	FOREIGN KEY (Driver_phone_num) REFERENCES DELIVERY_DRIVER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Request_ID) REFERENCES REQUEST(Request_ID)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE CUSTOMER_SERVICE (
	Phone_num	VARCHAR(15),
    PRIMARY KEY (Phone_num)
);

CREATE TABLE CONTACTS (
	Customer_phone_num		   VARCHAR(15),
    Customer_service_phone_num VARCHAR(15),
    PRIMARY KEY (Customer_phone_num, Customer_service_phone_num),
    FOREIGN KEY (Customer_phone_num) REFERENCES CUSTOMER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Customer_service_phone_num) REFERENCES CUSTOMER_SERVICE(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE COMMENTS_ON (
	Customer_phone_num	VARCHAR(15),
    Driver_phone_num	VARCHAR(15),
	Restaurant_addr 	VARCHAR(50),
    PRIMARY KEY (Customer_phone_num, Driver_phone_num, Restaurant_addr),
    FOREIGN KEY (Customer_phone_num) REFERENCES CUSTOMER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
	FOREIGN KEY (Driver_phone_num) REFERENCES DELIVERY_DRIVER(Phone_num)
				 ON DELETE RESTRICT	ON UPDATE CASCADE,
    FOREIGN KEY (Restaurant_addr) REFERENCES RESTAURANT(Addr)
				 ON DELETE RESTRICT	ON UPDATE CASCADE
);

CREATE TABLE COMMENTS_ON_C_AND_R (
	Customer_phone_num	VARCHAR(15),
	Restaurant_addr 	VARCHAR(50),
	R_rating_from_C		DECIMAL(2,1),
    Feedback_C_to_R		VARCHAR(50),
    PRIMARY KEY (Customer_phone_num, Restaurant_addr),
    FOREIGN KEY (Customer_phone_num) REFERENCES COMMENTS_ON(Customer_phone_num)
				 ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Restaurant_addr) REFERENCES COMMENTS_ON(Restaurant_addr)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COMMENTS_ON_C_AND_D (
	Customer_phone_num	VARCHAR(15),
    Driver_phone_num	VARCHAR(15),
    D_rating_of_C		DECIMAL(2,1),
    D_rating_from_C		DECIMAL(2,1),
    Feedback_C_to_D		VARCHAR(50),
    PRIMARY KEY (Customer_phone_num, Driver_phone_num),
    FOREIGN KEY (Customer_phone_num) REFERENCES COMMENTS_ON(Customer_phone_num)
				 ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Driver_phone_num) REFERENCES COMMENTS_ON(Driver_phone_num)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COMMENTS_ON_R_AND_D (
	Driver_phone_num	VARCHAR(15),
	Restaurant_addr		VARCHAR(50),
    R_rating_from_D		DECIMAL(2,1),
    D_rating_from_R 	DECIMAL(2,1),
    Feedback_R_to_D		VARCHAR(50),
    PRIMARY KEY (Driver_phone_num, Restaurant_addr),
	FOREIGN KEY (Restaurant_addr) REFERENCES COMMENTS_ON(Restaurant_addr)
				 ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Driver_phone_num) REFERENCES COMMENTS_ON(Driver_phone_num)
				 ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE TRANSPORTATION_METHOD ADD FOREIGN KEY (Car_license_plate_no) REFERENCES CAR(Car_license_plate_no) ON DELETE SET NULL ON UPDATE CASCADE;	
ALTER TABLE TRANSPORTATION_METHOD ADD FOREIGN KEY (Scooter_license_plate_no) REFERENCES SCOOTER(Scooter_license_plate_no) ON DELETE SET NULL ON UPDATE CASCADE;	
ALTER TABLE REQUEST ADD FOREIGN KEY (Driver_loc, Restaurant_addr, Customer_addr) REFERENCES REQUEST_DETAILS_FOR_DRIVER(Driver_loc, Restaurant_addr, Customer_addr) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ORDER_PAYMENT ADD FOREIGN KEY (Card_num) REFERENCES PAYMENT(Card_num) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE ORDER_PAYMENT ADD FOREIGN KEY (Order_num) REFERENCES ORDER_INFO(Order_num) ON DELETE RESTRICT ON UPDATE CASCADE;

/* Stored procedure that finds all restaurants (restaurant name, address, and phone number)
that have a rating of at least 4.5 stars for a given city and state abbreviation */
delimiter //
CREATE PROCEDURE find_rated_restaurants (IN City VARCHAR(15), IN State_Code CHAR(2),
										 OUT RName VARCHAR(25), OUT RAddr VARCHAR(50), OUT RPhNum VARCHAR(15))
BEGIN
	SELECT Restaurant_name, Addr, Phone_num INTO RName, RAddr, RPhNum
    FROM RESTAURANT
	WHERE Addr LIKE CONCAT('%', City, '%') AND
		  Addr LIKE CONCAT('%', State_Code, '%') AND
          Rating >= 4.5;
END//
delimiter ;

/* example call to procedure */
CALL find_rated_restaurants('Boston', 'MA', @RName, @RAddr, @RPhNum);


/* Stored procedure that finds all delivery drivers (first and last name, phone number)
who have completed a given number of deliveries */
delimiter //
CREATE PROCEDURE find_drivers (IN Deliveries INT, OUT Fname VARCHAR(15), OUT Lname VARCHAR(15), OUT PhNum VARCHAR(15))
BEGIN
	SELECT PERSON.Fname, PERSON.Lname, DELIVERY_DRIVER.Phone_num INTO FName, Lname, PhNum
    FROM PERSON, EMPLOYEE, DELIVERY_DRIVER, DRIVER_EARNINGS, DRIVER_ORDERS
	WHERE DRIVER_EARNINGS.Order_num = DRIVER_ORDERS.Order_num AND
		  DRIVER_ORDERS.Phone_num = DELIVERY_DRIVER.Phone_num AND 
          DELIVERY_DRIVER.Phone_num = EMPLOYEE.Phone_num AND
          EMPLOYEE.Phone_num = PERSON.Phone_num
    GROUP BY DELIVER_DRIVER.Phone_num
    HAVING COUNT(*) >= Deliveries;
END//
delimiter ;

/* example call to procedure */
CALL find_drivers(100, @Fname, @Lname, @PhNum);


/* Trigger code that will be executed when a new rating of a restaurant from a customer
is inserted into the COMMENTS_ON_C_AND_R table. It will update Rating in the RESTAURANT table. */
ALTER TABLE RESTAURANT ADD COLUMN Number_of_ratings INT DEFAULT 0;

delimiter // 
CREATE TRIGGER update_restaurant_rating AFTER INSERT ON COMMENTS_ON_C_AND_R
FOR EACH ROW 
BEGIN 
	IF NEW.COMMENTS_ON_C_AND_R.R_Rating_from_C IS NOT NULL THEN
		UPDATE RESTAURANT
        SET RESTAURANT.Number_of_ratings = RESTAURANT.Number_of_ratings + 1 AND
			RESTAURANT.Rating = (RESTAURANT.Rating * (RESTAURANT.Number_of_ratings - 1) + 
            NEW.COMMENTS_ON_C_AND_R.R_Rating_from_C) / RESTAURANT.Number_of_ratings
        WHERE RESTAURANT.Addr = COMMENTS_ON.Restaurant_addr AND 
			  COMMENTS_ON.Restaurant_addr = COMMENTS_ON_C_AND_R.Restaurant_addr;
	END IF;
END//
delimiter ;


/* Trigger code that will be executed when a new row is inserted into the DRIVER_EARNINGS table. 
It will update Total_earnings in the DELIVERY_DRIVER table. */
ALTER TABLE DELIVERY_DRIVER ADD COLUMN Total_earnings DECIMAL(10,2) DEFAULT 0;

delimiter // 
CREATE TRIGGER update_driver_earnings AFTER INSERT ON DRIVER_EARNINGS
FOR EACH ROW 
BEGIN 
	IF NEW.DRIVER_EARNINGS.Miles_driven IS NOT NULL THEN
		UPDATE DELIVERY_DRIVER
        SET DELIVERY_DRIVER.Total_earnings = DELIVERY_DRIVER.Total_earnings + 
			NEW.DRIVER_EARNINGS.Per_mile_rate * NEW.DRIVER_EARNINGS.Miles_driven + 
            NEW.DRIVER_EARNINGS.Pickup_earnings + NEW.DRIVER_EARNINGS.Dropoff_earnings +
            NEW.DRIVER_EARNINGS.Ctip
        WHERE DRIVER_EARNINGS.Order_num = DRIVER_ORDERS.Order_num AND 
			  DRIVER_ORDERS.Phone_num = DELIVERY_DRIVER.Phone_num;
	END IF;
END//
delimiter ;

/*
DROP TABLE COMMENTS_ON_R_AND_D;
DROP TABLE COMMENTS_ON_C_AND_D;
DROP TABLE COMMENTS_ON_C_AND_R;
DROP TABLE COMMENTS_ON;
DROP TABLE CONTACTS;
DROP TABLE CUSTOMER_SERVICE;
DROP TABLE RECEIVES;
DROP TABLE REQUEST;
DROP TABLE REQUEST_DETAILS_FOR_DRIVER;
DROP TABLE REGISTERS; 
DROP TABLE TRANSPORTATION_METHOD;
DROP TABLE SCOOTER;
DROP TABLE CAR;
DROP TABLE ORDER_PAYMENT;
DROP TABLE ORDER_INFO;
DROP TABLE PAYMENT;
DROP TABLE CART_ITEMS;
DROP TABLE CART;
DROP TABLE BROWSES;
DROP TABLE RESTAURANT_MENU;
DROP TABLE RESTAURANT_DEALS;
DROP TABLE RESTAURANT_HOURS;
DROP TABLE RESTAURANT_CATEGORY;
DROP TABLE RESTAURANT;
DROP TABLE APP_DESIGNER;
DROP TABLE DRIVER_ORDERS;
DROP TABLE DRIVER_EARNINGS;
DROP TABLE DELIVERY_DRIVER;
DROP TABLE CUSTOMER;
DROP TABLE EMPLOYEE;
DROP TABLE PERSON;
*/
