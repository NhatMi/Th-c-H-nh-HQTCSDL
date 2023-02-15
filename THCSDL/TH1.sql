
USE Sales
--1.
EXEC sp_addtype 'Mota','NVARCHAR(40)';
EXEC sp_addtype 'IDKH','CHAR(10)','NOT NULL';
EXEC sp_addtype 'DT', 'CHAR(12)';

--2.bang
CREATE TABLE SanPham
(
	Masp char(6) not null ,
	Tensp varchar(20),
	NgayNhap date,
	DVT char(10),
	SoLuongTon Int,
	DonGiaNhap money,
	primary key(Masp)
  )


  CREATE TABLE HoaDon
(
	MaHD char(10) not null,
	NgayLap  date not null,
	NgayGiao date not null,
	MaKH IDKH not null
	primary key(MaHD)
  )
   CREATE TABLE KhachHang
   (
   MaKH IDKH,
   TenKH nvarchar(30) ,
   DiaChi nvarchar(40) ,
   DienThoai DT,
   primary key (MaKH)
   )

   create table ChiTietHD
   (
		MaHD char(10) not null,
		Masp char(6) not null,
		SoLuong int
		primary key (MaHD, Masp)
   )
--3. 
ALTER TABLE HoaDon
ALTER COLUMN DienGiai nvarchar(100)
--4.
ALTER TABLE SanPham
ADD TyLeHoaHong float
--5.
ALTER TABLE SanPham
DROP COLUMN NgayNhap
--6.
ALTER TABLE HoaDon
ADD
CONSTRAINT fk_KhachHang_HoaDon FOREIGN KEY(MaKH) REFERENCES KhachHang(MakH)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT FK_HoaDon_ChiTietHD FOREIGN KEY(MaHD) REFERENCES HoaDon(MaHD),
CONSTRAINT FK_SanPham_ChiTietHD FOREIGN KEY(MaSp) REFERENCES SanPham(Masp)
--7.
------NgayGiao >= NgayLap---------
ALTER TABLE HoaDon
ADD CONSTRAINT check_Ngaygiao CHECK (Ngaygiao >= Ngaylap);
------MaHD gồm 6 ký tự, 2 ký tự đầu là chữ, các ký tự còn lại là số-----
ALTER TABLE HoaDon
ADD CONSTRAINT check_MaHD CHECK(MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]');
------Giá trị mặc định ban đầu cho cột NgayLap luôn luôn là ngày hiện hành-----
ALTER TABLE HoaDon
ADD CONSTRAINT df_Ngaylap DEFAULT GETDATE() FOR Ngaylap;

--8.
------SoLuongTon chỉ nhập từ 0 đến 500----
ALTER TABLE SanPham
ADD CONSTRAINT check_SoluongTon CHECK (SoluongTon BETWEEN 0 AND 500)
------DonGiaNhap lớn hơn 0------
ALTER TABLE SanPham
ADD CONSTRAINT check_DongiaNhap CHECK (DongiaNhap > 0)
------Giá trị mặc định cho NgayNhap là ngày hiện hành-----
ALTER TABLE SanPham
ADD CONSTRAINT df_NgayNhap DEFAULT GETDATE() FOR NgayNhap;
------DVT chỉ nhập vào các giá trị ‘KG’, ‘Thùng’, ‘Hộp’, ‘Cái’----
ALTER TABLE SanPham
ADD CONSTRAINT df_DVT CHECK (DVT = N'KG' or DVT = N'Thùng' or DVT = N'Hộp' or DVT = N'Cái')
--9.

INSERT INTO SanPham (Masp, Tensp, NgayNhap, DVT, SoluongTon, DongiaNhap, TyLeHoaHong)
 VALUES ('SP1', N'Bút chì', '2022-08-14', N'Cái', 200, 3000, 0.15)
 INSERT INTO SanPham (Masp, Tensp, NgayNhap, DVT, SoluongTon, DongiaNhap, TyLeHoaHong)
 VALUES ('SP2', N'Khẩu Trang', '2022-10-18', N'Thùng', 50, 2500, 0.10)
 INSERT INTO SanPham (Masp, Tensp, NgayNhap, DVT, SoluongTon, DongiaNhap, TyLeHoaHong)
 VALUES ('SP3', N'Bút Bi', '2022-10-25', N'Cái', 50, 5000, 0.15)

INSERT INTO KhachHang (MaKH, TenKH, Diachi, Dienthoai)
VALUES ('KH1', N'Minh Toàn', N'TP.HCM', '0945578442')
INSERT INTO KhachHang (MaKH, TenKH, Diachi, Dienthoai)
VALUES ('KH2', N'Toàn Thắng', N'Tây Ninh', '012345678')
INSERT INTO KhachHang (MaKH, TenKH, Diachi, Dienthoai)
VALUES ('KH3', N'Minh Thuận', N'Tây Ninh', '023145698')

INSERT INTO HoaDon (MaHD, Ngaylap, Ngaygiao, MaKH, Diengiai)
VALUES ('HD0001', '2022-08-16', '2022-08-25', 'KH1', N'Sản phẩm bút chì loại 1')
INSERT INTO HoaDon (MaHD, Ngaylap, Ngaygiao, MaKH, Diengiai)
VALUES ('HD0002', '2022-10-20', '2022-11-05', 'KH2', N'Sản phẩm khẩu trang kháng khuẩn')
INSERT INTO HoaDon (MaHD, Ngaylap, Ngaygiao, MaKH, Diengiai)
VALUES ('HD00013', '2022-08-25', '2022-08-30', 'KH3', N'Sản phẩm bút bi loại 1')

INSERT INTO ChiTietHD (MaHD, Masp, Soluong)
VALUES ('HD0001', 'SP1', 300)
INSERT INTO ChiTietHD (MaHD, Masp, Soluong)
VALUES ('HD0002', 'SP2', 800)
INSERT INTO ChiTietHD (MaHD, Masp, Soluong)
VALUES ('HD0005', 'SP3', 500)