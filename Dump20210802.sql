-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: 143.106.241.3    Database: cl19248
-- ------------------------------------------------------
-- Server version	5.6.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping events for database 'cl19248'
--

--
-- Dumping routines for database 'cl19248'
--
/*!50003 DROP PROCEDURE IF EXISTS `accounting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `accounting`(
idprovidr int(11))
BEGIN
set @bill = (select SUM(bilingprovider) as bill from tb_orders inner join tb_quotes where tb_orders.idquote = tb_quotes.idquote and tb_orders.idstatus = 6 and tb_quotes.idprovider = idprovidr);
set @points = (select SUM(points) as points from tb_orders inner join tb_quotes where tb_orders.idquote = tb_quotes.idquote and tb_orders.idstatus = 6 and tb_quotes.idprovider = idprovidr);

update tb_providers set billingprovider = @bill, accountbalance = @bill-floor(@points/10) where idprovider=idprovidr;
select accountbalance,billingprovider from tb_providers where idprovider=idprovidr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Delete_services` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Delete_services`(
idprovidr int(11),
idservic int(11)
)
BEGIN
declare cont integer;
set cont = (select COUNT(idquote) from tb_quotes inner join tb_servicesprovider using(idservice,idprovider) where tb_quotes.idservice = tb_servicesprovider.idservice and tb_quotes.idprovider = tb_servicesprovider.idprovider and tb_servicesprovider.idprovider = idprovidr and tb_servicesprovider.idservice = idservic and tb_quotes.idstatus != 8);
IF(cont = 0)  then
	delete from tb_servicesprovider where idservice = idservic and idprovider = idprovidr;
end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `myData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `myData`(
idprovidr int(11)
)
begin
set @idaddress = (select idaddress from tb_addressesproviders where idprovider = idprovidr);
select *
from tb_userprovider,tb_providers,tb_address 
where tb_userprovider.idprovider = idprovidr
and tb_providers.idprovider = idprovidr
and tb_address.idaddress = @idaddress;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Orders_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Orders_data`(
idprovidr int(11),
stats int(1)
)
BEGIN
DROP TEMPORARY TABLE IF EXISTS tmp_quotes;
create temporary table tmp_quotes as select idquote,vlquote,deadline,iduser as iuser,idaddress,idservice,idprovider,dtrequest,userdemand,duration,nrquote,execution,
IF(tb_quotes.idstatus = 1,"Orçamento realizado",IF(tb_quotes.idstatus = 2,"Orçamento aprovado pela empresa",iF(tb_quotes.idstatus = 3,"Orçamento rejeitado pela empresa",iF(tb_quotes.idstatus = 4,"Orçamento aprovado pelo cliente",iF(tb_quotes.idstatus = 5,"Orçamento rejeitado pelo cliente",iF(tb_quotes.idstatus = 6,"Pagamento efetuado",iF(tb_quotes.idstatus = 7,"Pedido em andamento","Pedido concluído"))))))) as idstatusO
from tb_quotes where idstatus = stats and idprovider = idprovidr;
 
DROP TEMPORARY TABLE IF EXISTS tmp_orders;
create temporary table tmp_orders as select * from tmp_quotes inner join tb_orders using(idquote) where tmp_quotes.idquote = tb_orders.idquote and tmp_quotes.iuser = tb_orders.iduser;

DROP TEMPORARY TABLE IF EXISTS tmp_address;
create temporary table tmp_address as select * from tmp_orders inner join tb_address using(idaddress) where tmp_orders.idaddress = tb_address.idaddress; 

DROP TEMPORARY TABLE IF EXISTS tmp_servicesprovider;
create temporary table tmp_servicesprovider as select idservice,idprovider,desserviceprovider,availabity from tmp_address inner join tb_servicesprovider using(idprovider,idservice) where tmp_address.idservice = tb_servicesprovider.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_services;
create temporary table tmp_services as select * from tmp_servicesprovider inner join tb_services using(idservice) where tmp_servicesprovider.idservice = tb_services.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_users;
create temporary table tmp_users as select * from tmp_services inner join tb_users using(iduser) where tmp_services.iduser = tb_users.iduser; 

DROP TEMPORARY TABLE IF EXISTS tmp_persons;
create temporary table tmp_persons as select * from tmp_users inner join tb_persons using(idperson) where tb_persons.idperson = tmp_users.idperson ; 

DROP TEMPORARY TABLE IF EXISTS tmp_allquoteSProvider;
create temporary table tmp_allquoteSProvider as select * from tmp_persons; 
 
select * from tmp_allorderSProvider;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Orders_Like` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Orders_Like`(
idprovidr int(11),
stats int(1),
texto varchar(150)
)
BEGIN
DROP TEMPORARY TABLE IF EXISTS tmp_quotes;
create temporary table tmp_quotes as select idquote,vlquote,deadline,iduser,idaddress,idservice,idprovider,dtrequest,userdemand,duration,nrquote,execution,
IF(tb_quotes.idstatus = 1,"Orçamento realizado",IF(tb_quotes.idstatus = 2,"Orçamento aprovado pela empresa",iF(tb_quotes.idstatus = 3,"Orçamento rejeitado pela empresa",iF(tb_quotes.idstatus = 4,"Orçamento aprovado pelo cliente",iF(tb_quotes.idstatus = 5,"Orçamento rejeitado pelo cliente",iF(tb_quotes.idstatus = 6,"Pagamento efetuado",iF(tb_quotes.idstatus = 7,"Pedido em andamento","Pedido concluído"))))))) as idstatusO
from tb_quotes where idstatus = stats and idprovider = idprovidr;
 
DROP TEMPORARY TABLE IF EXISTS tmp_orders;
create temporary table tmp_orders as select * from tmp_quotes inner join tb_orders using(idquote,iduser) where tmp_quotes.idquote = tb_orders.idquote and tmp_quotes.iduser = tb_orders.iduser;
 
DROP TEMPORARY TABLE IF EXISTS tmp_points;
create temporary table tmp_points as select idpoints,iduser,idorder,points as userpoints from tmp_orders inner join tb_userpoints using(idorder,iduser) where tmp_orders.idorder = tb_userpoints.idorder and tmp_orders.iduser = tb_userpoints.iduser and  tmp_orders.points != tb_userpoints.userpoints;
 
DROP TEMPORARY TABLE IF EXISTS tmp_address;
create temporary table tmp_address as select * from tmp_points inner join tb_address using(idaddress) where tmp_points.idaddress = tb_address.idaddress; 
 
DROP TEMPORARY TABLE IF EXISTS tmp_servicesprovider;
create temporary table tmp_servicesprovider as select idservice,idprovider,desserviceprovider,availabity from tmp_address inner join tb_servicesprovider using(idprovider,idservice) where tmp_address.idservice = tb_servicesprovider.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_services;
create temporary table tmp_services as select * from tmp_servicesprovider inner join tb_services using(idservice) where tmp_servicesprovider.idservice = tb_services.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_users;
create temporary table tmp_users as select * from tmp_services inner join tb_users using(iduser) where tmp_services.iduser = tb_users.iduser; 

DROP TEMPORARY TABLE IF EXISTS tmp_persons;
create temporary table tmp_persons as select * from tmp_users inner join tb_persons using(idperson) where tb_persons.idperson = tmp_users.idperson ; 

DROP TEMPORARY TABLE IF EXISTS tmp_allquoteSProvider;
create temporary table tmp_allquoteSProvider as select * from tmp_persons; 
 
select * from tmp_allorderSProviderwhere where desperson like CONCAT('%',texto,'%') 
or descity like CONCAT('%',texto,'%') or desservice like CONCAT('%',texto,'%') 
or paymentway like CONCAT('%',texto,'%') or bilingprovider like CONCAT('%',texto,'%') 
or typecard like CONCAT('%',texto,'%') or rating like CONCAT('%',texto,'%')
or idstatus like CONCAT('%',texto,'%') or nrorder like CONCAT('%',texto,'%')
or points like CONCAT('%',texto,'%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Pagar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Pagar`(
placaa varchar(7)
)
begin
SET SQL_SAFE_UPDATES=0;
update PAGAMENTO set qtde_parcela_paga = qtde_parcela_paga-1 where placa = placaa;
SET SQL_SAFE_UPDATES=1;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Provider_services` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Provider_services`(
idprovidr int(11)
)
BEGIN
select idservice, desservice, desserviceprovider, IF(tb_servicesprovider.availabity = 1,"Hoje",IF(tb_servicesprovider.availabity = 2,"Em 3 dias",IF(tb_servicesprovider.availabity = 3,"Em 1 semana","Em 1 mês"))) as availabity, rating
	from tb_services inner join tb_servicesprovider using(idservice)
	where tb_services.idservice = tb_servicesprovider.idservice and tb_servicesprovider.idprovider = idprovidr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Quotes_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Quotes_data`(
idprovidr int(11),
stats int(1)
)
BEGIN
DROP TEMPORARY TABLE IF EXISTS tmp_quotes;
create temporary table tmp_quotes as select idquote,vlquote,deadline,iduser,idaddress,idservice,idprovider,dtrequest,userdemand,duration,nrquote,execution,
IF(tb_quotes.idstatus = 1,"Orçamento realizado",IF(tb_quotes.idstatus = 2,"Orçamento aprovado pela empresa",iF(tb_quotes.idstatus = 3,"Orçamento rejeitado pela empresa","Orçamento rejeitado pelo cliente"))) as idstatus
from tb_quotes where idstatus = stats and idprovider = idprovidr;
 
DROP TEMPORARY TABLE IF EXISTS tmp_address;
create temporary table tmp_address as select * from tmp_quotes inner join tb_address using(idaddress) where tmp_quotes.idaddress = tb_address.idaddress; 
 
DROP TEMPORARY TABLE IF EXISTS tmp_servicesprovider;
create temporary table tmp_servicesprovider as select * from tmp_address inner join tb_servicesprovider using(idprovider,idservice) where tmp_address.idservice = tb_servicesprovider.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_services;
create temporary table tmp_services as select * from tmp_servicesprovider inner join tb_services using(idservice) where tmp_servicesprovider.idservice = tb_services.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_users;
create temporary table tmp_users as select * from tmp_services inner join tb_users using(iduser) where tmp_services.iduser = tb_users.iduser; 

DROP TEMPORARY TABLE IF EXISTS tmp_persons;
create temporary table tmp_persons as select * from tmp_users inner join tb_persons using(idperson) where tb_persons.idperson = tmp_users.idperson ; 

DROP TEMPORARY TABLE IF EXISTS tmp_allquoteSProvider;
create temporary table tmp_allquoteSProvider as select * from tmp_persons; 
 
select * from tmp_allquoteSProvider;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Quotes_Like` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Quotes_Like`(
idprovidr int(11),
stats int(1),
texto varchar(150)
)
BEGIN
DROP TEMPORARY TABLE IF EXISTS tmp_quotes;
create temporary table tmp_quotes as select idquote,vlquote,deadline,iduser,idaddress,idservice,idprovider,dtrequest,userdemand,duration,nrquote,execution,
IF(tb_quotes.idstatus = 1,"Orçamento realizado",IF(tb_quotes.idstatus = 2,"Orçamento aprovado pela empresa",iF(tb_quotes.idstatus = 3,"Orçamento rejeitado pela empresa",iF(tb_quotes.idstatus = 4,"Orçamento aprovado pelo cliente",iF(tb_quotes.idstatus = 5,"Orçamento rejeitado pelo cliente",iF(tb_quotes.idstatus = 6,"Pagamento efetuado",iF(tb_quotes.idstatus = 7,"Pedido em andamento","Pedido concluído"))))))) as idstatus
from tb_quotes where idstatus = stats and idprovider = idprovidr;
 
DROP TEMPORARY TABLE IF EXISTS tmp_address;
create temporary table tmp_address as select * from tmp_quotes inner join tb_address using(idaddress) where tmp_quotes.idaddress = tb_address.idaddress; 
 
DROP TEMPORARY TABLE IF EXISTS tmp_servicesprovider;
create temporary table tmp_servicesprovider as select * from tmp_address inner join tb_servicesprovider using(idprovider,idservice) where tmp_address.idservice = tb_servicesprovider.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_services;
create temporary table tmp_services as select * from tmp_servicesprovider inner join tb_services using(idservice) where tmp_servicesprovider.idservice = tb_services.idservice; 

DROP TEMPORARY TABLE IF EXISTS tmp_users;
create temporary table tmp_users as select * from tmp_services inner join tb_users using(iduser) where tmp_services.iduser = tb_users.iduser; 

DROP TEMPORARY TABLE IF EXISTS tmp_persons;
create temporary table tmp_persons as select * from tmp_users inner join tb_persons using(idperson) where tb_persons.idperson = tmp_users.idperson ; 

DROP TEMPORARY TABLE IF EXISTS tmp_allquoteSProvider;
create temporary table tmp_allquoteSProvider as select * from tmp_persons; 
 
select * from tmp_allquoteSProvider where desperson like CONCAT('%',texto,'%') 
or descity like CONCAT('%',texto,'%') or desservice like CONCAT('%',texto,'%') 
or duration like CONCAT('%',texto,'%') or vlquote like CONCAT('%',texto,'%') 
or dtrequest like CONCAT('%',texto,'%') or deadline like CONCAT('%',texto,'%') 
or userdemand like CONCAT('%',texto,'%') or execution like CONCAT('%',texto,'%') 
or idstatus like CONCAT('%',texto,'%') or nrquote like CONCAT('%',texto,'%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registering_Services` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `registering_Services`(
deslogin VARCHAR(64),
despassword VARCHAR(256),
desserviceprovider VARCHAR(352),
vlprice DECIMAL(10,2),
deservice varchar(256)
)
begin
set @idprovider = (select idprovider from tb_userprovider where deslogin = deslogin and despassword = despassword);
set @idservice = (select idservice from tb_services where desservice = deservice);
insert into tb_servicesprovider (idprovider,idservice,desserviceprovider,vlprice) values (@idprovider,@idservice,desserviceprovider,vlprice);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registering_UserProvider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `registering_UserProvider`(
dszipcode int(8),
dsaddress varchar(128),
dsnumber int(11),
dscity varchar(32),
dsstate varchar(32),
dscountry varchar(32),
dsneighborhood varchar(32),
dscomplement varchar(32),
dscnpj varchar(14),
dsprovider varchar(64),
nphone bigint(20),
dslogin varchar(64),
dspassword varchar(256),
dsemail varchar(64),
imguserprovider MEDIUMBLOB
)
begin
set @MAXnrprovider = (select MAX(nrprovider) from tb_providers)+1;
insert into tb_providers(descnpj,desprovider,nrphone,desemail,billingprovider,accountbalance,nrprovider) values (dscnpj,dsprovider,nphone,dsemail,0.00,0.00,@MAXnrprovider);
set @id_tb_providers = last_insert_id();

if imguserprovider = null then
	insert into tb_userprovider(deslogin,despassword,idprovider) values (dslogin,dspassword,@id_tb_providers);
else
	insert into tb_userprovider(deslogin,despassword,idprovider,imguserprovider) values (dslogin,dspassword,@id_tb_providers,imguserprovider);
end if;

if dscomplement = null then
	insert into tb_address(deszipcode,desaddress,desnumber,descity,desstate,descountry,desneighborhood) values (dszipcode,dsaddress,dsnumber,dscity,dsstate,dscountry,dsneighborhood);
else
	insert into tb_address(deszipcode,desaddress,desnumber,descity,desstate,descountry,desneighborhood,descomplement) values (dszipcode,dsaddress,dsnumber,dscity,dsstate,dscountry,dsneighborhood,dscomplement);
end if;

insert into tb_addressesproviders(idaddress,idprovider) values (LAST_INSERT_ID(),@id_tb_providers);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Retirar_pagto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Retirar_pagto`(
idprovidr int(11),
retirar double
)
BEGIN
update tb_providers set accountbalance = accountbalance-retirar where idprovider = idprovidr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updating_UserProvider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `updating_UserProvider`(
dszipcode int(8),
dsaddress varchar(128),
dsnumber int(11),
dscity varchar(32),
dsstate varchar(32),
dscountry varchar(32),
dsneighborhood varchar(32),
dscomplement varchar(32),
dscnpj varchar(14),
dsprovider varchar(64),
nphone bigint(20),
dslogin varchar(64),
dsemail varchar(64),
imguserprovidr MEDIUMBLOB,
idprovidr int(11)
)
begin
update tb_providers set descnpj=dscnpj,desprovider=dsprovider,nrphone=nphone, desemail=dsemail where idprovider = idprovidr;

if imguserprovidr = null then
	update tb_userprovider set deslogin=dslogin where idprovider = idprovidr;
else
	update tb_userprovider set deslogin=dslogin,imguserprovider=imguserprovidr where idprovider = idprovidr;
end if;

set @idaddress = (select idaddress from tb_addressesproviders where idprovider = idprovidr);

if dscomplement = null then
	update tb_address set deszipcode=dszipcode,desaddress=dsaddress,desnumber=dsnumber,descity=dscity,desstate=dsstate,descountry=dscountry,desneighborhood=dsneighborhood where idaddress=@idaddress;
else
	update tb_address set deszipcode=dszipcode,desaddress=dsaddress,desnumber=dsnumber,descity=dscity,desstate=dsstate,descountry=dscountry,desneighborhood=dsneighborhood,descomplement=dscomplement where idaddress=@idaddress;
end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Veiculo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cl19248`@`%` PROCEDURE `Veiculo`(
placa varchar(7),
valor_veiculo float,
valor_imposto float, 
forma_pagto int,
qtde_parcela_paga int
)
begin
insert into VEICULO(placa,valor_veiculo,valor_imposto, forma_pagto) values (placa,valor_veiculo,valor_imposto, forma_pagto);
insert into PAGAMENTO (placa,qtde_parcela_paga) values (placa,qtde_parcela_paga);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-02 13:39:24
