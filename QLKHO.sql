USE QLKHO
CREATE TABLE TON
(
	MaVT VARCHAR(10) PRIMARY KEY,
	TenVT VARCHAR(10),
	SoLuongT INT,
)
CREATE TABLE NHAP
(
	SoHDN VARCHAR(10) PRIMARY KEY ,
	MaVT VARCHAR(10) FOREIGN KEY REFERENCES TON (MaVT),
	SoLuongN INT,
	DonGiaN FLOAT,
	NgayN DATETIME
	
)
GO
CREATE TABLE XUAT
(
	SoHDX VARCHAR (10) PRIMARY KEY,
	MaVT VARCHAR(10) FOREIGN KEY REFERENCES TON (MaVT),
	SoLuongX INT,
	DonGiaX FLOAT,
	NgayX DATETIME
)
GO 
INSERT INTO TON
(MaVT, TenVT, SoLuongT)
values
('M1', 'Gỗ Lim', '500'),
('M2', 'Gỗ Xưa', '400'),
('M3', 'Gỗ Tùng', '250'),
('M4', 'Gỗ Lậu', '200'),
('M5', 'Gỗ Trầm', '150')

INSERT INTO NHAP
(SoHDN,MaVT, SoLuongN, DonGiaN, NgayN)
values
('1', 'M1', '200', '30000', '2021/01/22'),
('2', 'M5', '100', '50000', '2022/01/20'),
('3', 'M3', '150', '10000', '2022/03/21')

INSERT INTO XUAT
(SoHDX, MaVT, SoLuongX, DonGiaX, NgayX)
values
('1', 'M2', '200', '3500000000', '2022/01/20'),
('2', 'M4', '150', '1500000000', '2023/01/20')

---Câu2
CREATE VIEW QLKHO 
AS
select TON.MaVT,TenVT,sum(SoLuongX*DonGiaX) as "tien ban"
from XUAT inner join TON on XUAT.MaVT=TON.MaVT
group by TON.MaVT,TenVT
GO
SELECT * FROM QLKHO

-------
---Câu3
CREATE VIEW QLKHO_CAU3
AS
select TON.TenVT, sum(SoLuongX) as "tong sl"
from XUAT inner join TON on XUAT.MaVT=TON.MaVT
group by TON.TenVT
GO
SELECT * FROM QLKHO_CAU3

-----câu 4----
CREATE VIEW QLKHO_CAU4
AS
select TON.TenVT, sum(SoLuongN) as "tong sl"
from NHAP inner join TON on NHAP.MaVT=TON.MaVT
group by TON.TenVT
GO
SELECT * FROM QLKHO_CAU4

---Câu5-----
CREATE VIEW QLKHO_C5
AS
select TON.MaVT,TON.TenVT,sum(SoLuongN)-sum(SoLuongX) +
sum(SoLuongT) as TONGTON
from NHAP inner join TON on NHAP.MaVT=TON.MaVT
inner join XUAT on TON.MaVT=XUAT.MaVT
group by TON.MaVT,TON.TenVT

GO
SELECT * FROM QLKHO_C5

----cấu 6 ----
CREATE VIEW QLKHO_CAU6
AS
select TenVT
from TON
where SoLuongT = (select max(SoLuongT) from TON)

-----câu 7------
CREATE VIEW QLKHO_CAU7
AS
select TON.MaVT,TON.TenVT
from TON inner join xuat on TON.MaVT=xuat.MaVT
group by TON.MaVT,TON.TenVT
having sum(SoLuongX)>=100 
------CÂU 8 ------
