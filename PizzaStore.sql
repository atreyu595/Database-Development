-- Created in August 2019
-- Finished and polished the Database Architecture early 2020
-- Added SQL queries for learning purposes 
-- Author: Atreyu Jasper Laxa Cortez

drop table ShopWorkerShift 
drop table shopWorker
drop table DriverShift--since drivershift is the parent which calls upon the fk, the parent is removed first before all the fk
drop table deliveryDriver
drop table cardPayment--before pickUpOrder 
drop table creditPayment
drop table cashPayment
drop table InstorePay
drop table pickUpOrder--before phone
drop table deliveryOrder
drop table areSupplied
drop table ingredientInfo
drop table ingredientDetails
drop table isPlacedOn
drop table OrderDriverInfo
drop table phone
drop table WalkIn
drop table ComprisesOf
drop table canComeFrom
drop table quantityItem
drop table quantityPrice
drop table menuItem
drop table ingredientOrder
drop table Supplier
drop table ingredientData
drop table DeliveryPay
drop table staffPayment
drop table shiftData
drop table OrderTable--which ever table has the FK drop first--
drop table customer
drop table employee

create table customer (customerID char(10) primary key, firstName char(20), lastName char(10), 
						addresss varchar(20), phoneNumber varchar(20));

create table employee(employeeID char(10) primary key, firstName varchar(20), 
						lastName varchar(20), postalAddres varchar(20), contactNumber varchar(20),
						taxFileNumber varchar(20), bankDetails varchar(20), paymentRate dec(4,2), 
						statuss varchar(10), descriptions  varchar(20));

create table OrderTable(orderID char(10) Primary Key, 
	orderDate date, ordertime time, 
		customerID char(10), employeeID char(10),
		itemName varchar(20), itemPrice dec(4,2),
		totalAmountDue dec(4,2), description varchar(20), foreign key(customerID) 
		references customer(customerID) on update cascade on delete no action, foreign key(employeeID) 
		references employee(employeeID) on update cascade on delete no action); 

create table staffPayment(paymentID char(10) primary key, taxWithheld dec(5,2), totalAmountPaid dec(5,2), 
							paymentPeriodStartDate date, paymentPeriodEndDate date, 
							bankDetails varchar(20));

create table ingredientData (code char(10) primary key, ingredientName varchar(20), 
								type varchar(20), description varchar(20), stockLevelCurrent varchar(20),
								lastStockTakeDate date, suggestStock varchar(20));

create table supplier (supplierID char(10) primary key, name varchar(20), address varchar(20), 
						BusinessNumber varchar(20), phoneNumber varchar(20), email varchar(20));

create table ingredientOrder (orderNo varchar(5) primary key, totalAmount dec(9,2), 
							  status varchar(20), description varchar(20), supplierID char(10), code char(10), 
							  ingredientDate date, ingredientDateRecieved date,
							  foreign key(supplierID) references supplier(supplierID) on update cascade on delete no action);

--Must ensure that foreign keys must have their referenced tables above the table thats referencing the, e.g. ingredientOrder and supplier
create table quantityItem (code char(10) primary key, quantity varchar(20) default(0));--deault 2

create table quantityPrice (code char(10) primary key, price dec(9,2) default(0.00))--default 3

create table menuItem(itemCode char(10) primary key, name char(20), size char(20), sellingPrice dec(4,2));

create table canComeFrom (orderID char(10), itemCode char(10),
							quantityItem char(10), primary key(orderID, itemCode, quantityItem),
							foreign key(orderID) references OrderTable(orderID) on update cascade on delete no action,
							foreign key(itemCode) references menuItem(itemCode) on update cascade on delete no action);

create table ComprisesOf (itemCode char(10), code char(10), quantityItem varchar(20), 
							primary key(itemCode, code, quantityItem), 
							foreign key (itemCode) references menuItem(itemCode) on update cascade on delete no action,
							foreign key(code) references ingredientData(code) on update cascade on delete no action);


create table areSupplied(code char(10), supplierID char(10), quantity varchar(20), price dec(9,2)
						primary key(code, supplierID, quantity, price), 
						foreign key(code) references ingredientData(code) on update cascade on delete no action, 
						foreign key(supplierID) references supplier(supplierID) on update cascade on delete no action);

create table ingredientDetails(ingredientNo char(10) primary key, quantityIngredient varchar(10));

create table ingredientInfo(orderNo varchar(5), ingredientNo char(10), primary key(orderNo, ingredientNo),
							foreign key(ingredientNo) references ingredientDetails(ingredientNo) on update cascade on delete no action, 
							foreign key(orderNo) references ingredientOrder(orderNo) on update cascade on delete no action);

create table isPlacedOn(orderNo varchar(5), code char(10), quantityItem varchar(10), 
						primary key(orderNo, code, quantityItem),
						foreign key(orderNo) references ingredientOrder(OrderNo) on update cascade on delete no action,
						foreign key(code) references ingredientData(code) on update cascade on delete no action);

create table shiftData(shiftID varchar(10) primary key, startTime time, endTime time, startDate date, endDate date)
						
create table OrderDriverInfo(shiftID varchar(10), deliveryAddress varchar(20), timeDelivery time,
							foreign key(shiftID) references shiftData(shiftID) on update cascade on delete no action);

create table deliveryPay (paymentID char(10) primary key, deliveriesPaid varchar(30) default(0), ---default 1
						foreign key(paymentID) references staffPayment(paymentID) on update cascade on delete no action);

create table InstorePay (paymentID char(10) primary key, hoursPaid dec(4,2), 
						foreign key(paymentID) references staffPayment(paymentID) on update cascade on delete no action);

create table phone (orderID char(10) primary key, 
					foreign key(orderID) references OrderTable(orderID) on update cascade on delete no action, 
					customerName varchar(20), customerAddress varchar(20), callAnswered time, callTerminated time);

create table pickUpOrder(orderID char(10) primary key, pickUpTime time, foreign key(orderID) references phone(orderID));

create table deliveryOrder(orderID char(10) primary key, foreign key(orderID) references phone(orderID) on
							update cascade on delete no action,
							deliveryDriver varchar(10), deliveryAddress varchar(20), deliverTime time);

create table WalkIn (orderID char(10) primary key, timeWalkedIn time, 
					foreign key (orderID) references OrderTable(orderID) on update cascade on delete no action); 

create table shopWorker (employeeID char(10) primary key, hourlyPay dec(4,2), 
						foreign key(employeeID) references employee(employeeID) on update cascade on delete no action);   

create table deliveryDriver (employeeID char(10) primary key, NoOfDeliveries varchar(10), licenceNo varchar(20), 
							foreign key(employeeID) references employee(employeeID) on update cascade on delete no action);

create table shopWorkerShift(shiftID varchar(10) primary key, paymentID char(10), employeeID char(10), HoursWorked varchar(10), 
							foreign key(shiftID) references shiftData(shiftID) on update cascade on delete no action, 
							foreign key(paymentID) references InstorePay(paymentID) on update cascade on delete no action, 
							foreign key(employeeID) references shopWorker(employeeID) on update cascade on delete no action);
--DriverShift must be dropped before all of the FK it states
create table DriverShift(shiftID varchar(10) primary key, DeliveriesMade varchar(20), employeeID char(10), orderID char(10),
						foreign key(orderID) references deliveryOrder(orderID), 
						foreign key(employeeID) references deliveryDriver(employeeID) on update
						cascade on delete no action, paymentID char(10), 
						foreign key(paymentID) references deliveryPay(paymentID) on update 
						cascade on delete no action, foreign key(shiftID) references shiftData(shiftID) on update cascade on
						delete no action);

create table cardPayment (orderID char(10) primary key, foreign key(orderID) references phone(orderID) on update
						 cascade on delete no action, paymentApprovalNo varchar(20));


create table creditPayment (orderID char(10) primary key, foreign key(orderID) references phone(orderID) on update
							cascade on delete no action, creditNo char(10));

create table cashPayment (orderID char(10) primary key, foreign key(orderID) references phone(orderID) on update 
						 cascade on delete no action, amountOfCash dec(6,2));


insert into customer values ('LG323', 'James', 'Charles', '11 Budgeree Drive', '042342123421')
insert into customer values ('LG324', 'Jasper', 'Cortez', '67 Beal Street', '042447698343')
insert into customer values ('LG325', 'Kyle', 'Dryden', '34 Beamish Street', '04579979879')
insert into customer values ('LG326', 'Mitchell', 'Harland', '87 Babaderoo Drive', '043452456774')
insert into customer values ('LG327', 'Corey', 'Gunn', '178 Hill Street', '043452351346')

insert into employee values ('WB789', 'Sabrina', 'Hudson', '98 Hed Road', '0468738977', '589787878978', '8978782726', '25.00', 'Employed', 'Delivery Driver')
insert into employee values ('WB790', 'Ivan', 'Keel', '177 Wollobu Circuit', '0412788121', '2389787998', '232388928', '19.00', 'Employed', 'Shop Worker')
insert into employee values ('WB791', 'Sven', 'Ulreich', '23 Oslow Drivve', '0413289272', '57689978138', '2438789432', '23.00', 'Employed', 'Delivery Driver')
insert into employee values ('WB792', 'James', 'Milner', '45 Poil Circuit', '04123451434', '572324324234', '14534565667', '23.00', 'Employed', 'Shop Worker')
insert into employee values ('WB793', 'Yen', 'So', '23 Cliff Street', '0423412341', '2411245252', '1232134423', '22.00', 'Employed', 'Shop Worker')
insert into employee values ('WB794', 'Lee', 'Dong', '34 Yarbo Road', '042412351245', '2412134234', '12342315445', '24.00', 'Employed', 'Delivery Driver')
insert into employee values ('WB795', 'James', 'Patrick', '21 Crescent Street', '04341234235', '2341245545', '13421524551', NULL, 'Dismissed', NULL)

--string or binary data would be truncated, reduce the size of a long looking value that doesn't correspond to parameter size in table--

insert into OrderTable values ('PO12', '2012-10-09', '13:44:09', 'LG323', 'WB789', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza')
insert into OrderTable values ('PO13', '2012-10-10', '15:08:13', 'LG324', 'WB791', 'Cheese Pizza', '10.00', '10.00', 'Medium Cheese Pizza')
insert into OrderTable values ('PO14', '2012-07-09', '16:38:45', 'LG325', 'WB790', 'Sausage Pizza', '23.00', '23.00', 'ExLarge Pizza')
insert into OrderTable values ('PO15', '2012-09-12', '13:44:09', 'LG325', 'WB791', 'Pepperoni Pizza', '14.00', '14.00', 'Pepperoni Pizza')
insert into OrderTable values ('PO16', '2012-09-13', '12:22:12', 'LG326', 'WB792', 'Cheese Pizza', '10.00', '10.00', 'Medium Cheese Pizza')
insert into OrderTable values ('PO17', '2012-09-17', '15:09:20', 'LG327', 'WB789', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza') 
insert into OrderTable values ('PO18', '2012-09-21', '15:57:01', 'LG327', 'WB794', NULL, NULL, NULL, 'Cancelled')
insert into OrderTable values ('PO19', '2012-10-07', '13:23:09', 'LG324', 'WB794', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza')
insert into OrderTable values ('PO20', '2019-12-09', '14:56:09', 'LG323', 'WB789', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza')
insert into OrderTable values ('PO21', '2019-12-30', '17:57:08', 'LG327', 'WB790', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza')
insert into OrderTable values ('PO22', '2019-07-12', '13:52:00', 'LG324', 'WB789', 'Sausage Pizza', '12.00', '12.00', 'Large Sausage Pizza')
insert into OrderTable values ('PO23', '2019-04-19', '09:23:09', 'LG324', 'WB790', 'Pepperoni Pizza', '14.00', '14.00', 'Large Pep Pizza')

insert into menuItem values ('ZYUI', 'Sausage', 'Large', '12.00')
insert into menuItem values ('XPOI', 'Cheese', 'Large', '10.00')
insert into menuItem values ('YLWE', 'Pepperoni', 'Large', '14.00')

insert into shiftData values ('RUIK', '13:40:00', '21:40:00', '2019-12-09', '2019-12-09')
insert into shiftData values ('WUIE', '16:25:00', '20:25:00', '2019-12-10', '2019-12-10')
insert into shiftData values ('POLE', '11:30:00', '19:30:00', '2019-12-11', '2019-12-11')
insert into shiftData values ('YUEI', '13:40:23', '18:40:23', '2019-12-11', '2019-12-11')
insert into shiftData values ('POIU', '17:33:00', '23:33:00', '2019-04-12', '2019-04-12')
insert into shiftData values ('WERT', '09:30:00', '15:30:00', '2019-05-14', '2019-05-14')

insert into ingredientDetails values ('LOIK', '200')
insert into ingredientDetails values ('POWQ', '300')
insert into ingredientDetails values ('ERUY', '250')

insert into supplier values ('POIWL', 'Kahns Specials', '09892HIJ92', '02-4312414214', 'kahn@yahoo.com', 'James') 
insert into supplier values ('UYIL', 'Gourmet Chef', '0754HUIJ91', '02-4981082981', 'Chef@gmail.com', 'Curtis')
insert into supplier values ('UOLI', 'The Market', '01236HNINI9', '02-4828078921', 'Market@hotmail.com', 'Lee')

insert into ingredientData values ('QWERTY', 'Sausage', 'Meat', 'German Sausages', '25 Current', '2019-04-19', '100 suggested') 
insert into ingredientData values ('POQYIU', 'Cheese', 'Dairy', 'Mozarella', '45 current', '2019-04-27', '200 suggested')
insert into ingredientData values ('PYPIWE', 'Pepperoni', 'Cured/Meat', 'Italian Pepperoni', '78 current', '2019-05-12', '210 suggested')

--if it comes up with column name or number of values doesn't match parameters etc, retype the same insertion again--
--it you want to add something in data, first change the data in create table, then delete the old insert of that table, execute, the paste it back on execute again
insert into ingredientOrder values ('KILO', '1000.00', 'Processing', 'Ordering', 'POIWL', 'QWERTY', '2019-12-23', '2019-12-24')
insert into ingredientOrder values ('IUYO', '350.00', 'Processed', 'Delivered', 'UYIL', 'PYPIWE', '2019-12-21', '2019-12-25')
insert into ingredientOrder values ('WVGR', '700.00', 'Processed', 'Delivered', 'UOLI', 'POQYIU', '2019-12-10', '2019-12-15')

--arithemetic overflow error, check dec() places for table
--conversion from date or time to string, check that the date is in the right format
insert into staffPayment values ('OUYIK', '102.00', '789.12', '2019-11-23', '2019-11-29',  '2438789432')
insert into staffPayment values ('POQWM', '209.23', '890.39', '2019-12-27', '2019-12-31', '232388928')
insert into staffPayment values ('ERWTY', '101.79', '650.98', '2019-01-11', '2019-01-17', '8978782726')
insert into staffPayment values ('WQYTI', '98.99', '567.23', '2019-03-14', '2019-03-19', '14534565667')
insert into staffPayment values ('QWIUY', '72.00', '234.00', '2019-04-13', '2019-04-18', '1232134423')
insert into staffPayment values ('GHEYM', '39.00', '347.98', '2019-04-14', '2019-04-19', '12342315445')
insert into staffPayment values ('YUIKO', '32.00', '560.98', '2019-04-19', '2019-04-24', '2438789432')

insert into WalkIn values ('PO12', '13:40:09')
insert into WalkIn values ('PO13', '12:40:12')
insert into WalkIn values ('PO16', '18:23:13')

insert into shopWorker values ('WB790', '19.00')
insert into shopWorker values ('WB792', '23.00')
insert into shopWorker values ('WB793', '22.00')

insert into InstorePay values ('POQWM', '36.98')
insert into InstorePay values ('WQYTI', '42.24')
insert into InstorePay values ('GHEYM', '35.20')

insert into deliveryPay values ('OUYIK', '19 deliveries')
insert into deliveryPay values ('ERWTY', '25 deliveries')
insert into deliveryPay values ('QWIUY', '22 deliveries')
insert into deliveryPay(paymentID) values ('YUIKO')--example default 1

insert into shopWorkerShift values ('RUIK', 'POQWM', 'WB790', '36 hours')
insert into shopWorkerShift values ('YUEI', 'WQYTI', 'WB792', '42 hours')
insert into shopWorkerShift values ('WERT', 'GHEYM', 'WB793', '35 hours')

insert into deliveryDriver values ('WB789', '23', '27342487879')
insert into deliveryDriver values ('WB791', '17', '12342134234')
insert into deliveryDriver values ('WB792', '12', '34523453532') 

insert into phone values ('PO14', 'James', 'Won', '13:25:09', '13:27:09') 
insert into phone values ('PO15', 'Tara', 'Street', '12:09:02', '14:15:45')
insert into phone values ('PO17', 'Ashleigh', 'Geel', '15:56:34', '15:59:09')
insert into phone values ('PO19', 'Kayln', 'Rew', '13:09:11', '14:52: 23')
insert into phone values ('PO18', 'Ike', 'Po', '12:56:09', '13:56:26')
insert into phone values ('PO20', 'Rhys', 'Martin', '22:09:00', '23:11:07')
insert into phone values ('PO21', 'Ysobel', 'Martin', '21:00:00', '21:10:00')
insert into phone values ('PO22', 'Waluigi', 'Dicaprio', '14:00:00', '14:12:00')
insert into phone values ('PO23', 'Luigi', 'Bowser', '12:00:00', '12:10:00')

insert into deliveryOrder values ('PO14', 'Sabrina', '11 Bingara Road', '19:56:09')
insert into deliveryOrder values ('PO15', 'Sven', '12 Steel Street', '22:52:09')
insert into deliveryOrder values ('PO17', 'James', '34 Farley Street', '20:34:09')

insert into DriverShift values ('WUIE', '19 delivery', 'WB789', 'PO14', 'OUYIK') 
insert into DriverShift values ('POLE', '22 delivery', 'WB791', 'PO15', 'ERWTY')
insert into DriverShift values ('POIU', '21 delivery', 'WB792', 'PO17', 'QWIUY')

insert into canComeFrom values ('PO12', 'ZYUI', '7')
insert into canComeFrom values ('PO13', 'XPOI', '12')
insert into canComeFrom values ('PO14', 'ZYUI', '9')

insert into ComprisesOf values ('ZYUI', 'QWERTY', '12')
insert into ComprisesOf values ('XPOI', 'PYPIWE', '17')
insert into ComprisesOf values ('ZYUI', 'QWERTY', '14')

insert into isPlacedOn values ('KILO', 'QWERTY', '300')
insert into isPlacedOn values ('IUYO', 'PYPIWE', '400')
insert into isPlacedOn values ('WVGR', 'POQYIU', '460')

insert into areSupplied values ('POQYIU', 'UYIL', '400 quantities', '200.00')
insert into areSupplied values ('PYPIWE', 'UOLI', '200 quantities', '300.00')
insert into areSupplied values ('POQYIU', 'UYIL', '200 quantities', '109.00')

insert into ingredientInfo values ('KILO', 'LOIK')
insert into ingredientInfo values ('IUYO', 'POWQ')
insert into ingredientInfo values ('WVGR', 'ERUY')

insert into OrderDriverInfo values ('WUIE', '11 Bingara Road', '19:56:09')
insert into OrderDriverInfo values ('POLE', '12 Steel Street', '22:52:09')
insert into OrderDriverInfo values ('POIU', '34 Farley Street', '20:34:09')

insert into pickUpOrder values ('PO18', '14:10:00')
insert into pickUpOrder values ('PO19', '15:11:00')
insert into pickUpOrder values ('PO20', '23:22:00')

insert into cardPayment values ('PO14', '1232134245')
insert into cardPayment values ('PO15', '4523453245')
insert into cardPayment values ('PO21', '2123423441')

insert into cashPayment values ('PO18', '24.00')
insert into cashPayment values ('PO19', '50.00')
insert into cashPayment values ('PO22', '35.00')

insert into creditPayment values ('PO17', '454565635')
insert into creditPayment values ('PO20', '356456356')
insert into creditPayment values ('PO23', '389123424')

insert into quantityItem values ('QWERTY', '3 ingredient(s)')
insert into quantityItem values ('ZYUI', 'Sausage')
insert into quantityItem values ('PO14', '2 items')
insert into quantityItem(code) values ('poij')---Example 2 default

insert into quantityPrice values ('QWERTY', '1000.00')
insert into quantityPrice values ('PYPIWE', '350.00')
insert into quantityPrice values ('POQYIU', '700.00')
insert into quantityPrice(code) values ('qwer')--Example 3 default

--violation of primary key, duplicate key values...check for the same input in values
select employee.employeeID, firstName, lastName, hourlyPay
from employee, shopWorker
where employee.employeeID = shopWorker.employeeID AND descriptions = 'Shop Worker';

select DriverShift.shiftID, firstName, lastName, startTime , endTime , startDate, endDate  
from shiftData, DriverShift, employee
where DriverShift.employeeID = employee.employeeID AND DriverShift.shiftId = shiftData.shiftID
group by DriverShift.shiftID, firstName, lastName, startTime , endTime , startDate, endDate

select distinct (OrderTable.orderID), itemName, firstName, orderDate, ordertime, 
		customer.customerID, employeeID,
		itemName, itemPrice,
		totalAmountDue, description 
from customer, OrderTable, WalkIn
where OrderTable.orderID = WalkIn.orderID AND customer.customerID = OrderTable.customerID --to prevent duplicating data ensure all primary keys are equeated to each kind of table
group by OrderTable.orderID, firstName, itemName,  firstName, orderDate, ordertime, 
		customer.customerID, employeeID,
		itemName, itemPrice,
		totalAmountDue, description 

--if it asks to go and check the column name of a table after coming back from something, just log off and on again

select      ingredientName, name, ingredientDateRecieved, i.supplierID
FROM	    ingredientData, ingredientOrder i left JOIN   supplier s  ON (i.supplierID = s.supplierID)
GROUP BY	name, ingredientDateRecieved, ingredientName, i.supplierID

