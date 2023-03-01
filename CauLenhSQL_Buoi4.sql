-----các câu lệnh SQL

-----C1
select * from NHANVIEN
-----C2
select MaNV, HoNV, TenLot, TenNV, NgSinh, Diachi, Phai, Luong, Phong
from NHANVIEN
where Phong=5
-----C3
select HoNV, Tenlot, TenNV, Luong, Phong
from NHANVIEN
where Luong > 6000000
-----C4
select MaNV, Tenlot, TenNV, Luong, Phong
from NHANVIEN
where Phong = 1 AND Luong >6500000 OR
	  Luong > 5000000 AND Phong =4
-----C5
select MANV, HONV, TENLOT, TENNV
from NHANVIEN , Diachi_phong
where NHANVIEN.Phong = diachi_phong.maphg and diachi_phong.DIAchi = 'QUANG NGAI'

select *from NHANVIEN
-----C6
select HoNV+''+TenLot+''+TenNV+'' as' họ và tên nhân viên'
from NHANVIEN
where NHANVIEN.HoNV like N'N%'
-----C7
SELECT NHANVIEN.NGSINH, NHANVIEN.DiaCHI
FROM NHANVIEN
WHERE NHANVIEN.HONV = N'Cao' AND
		  NHANVIEN.TENLOT = N'Thanh' AND
		  NHANVIEN.TENNV = N'Huyền'

-----C8
select *FROM NHANVIEN
WHERE Year(NGSINH) BETWEEN 1955 AND 1975;
-----C9
Select HONV + ' ' +TENLOT+ ' ' +TENNV as 'Họ Và Tên' , YEAR(NGSINH) as 'Năm Sinh của sinh viên: '
from NHANVIEN
-----C10

select HONV+ ' ' +TENLOT+ ' ' +TENNV as 'Họ và tên', (2023 - YEAR(NGSINH)) as 'Tuổi nhân viên' from NHANVIEN

-----C11

select HONV+ ' ' +TENLOT+ ' ' +TENNV as 'Họ và tên Trưởng Phòng' from PHONGBAN,NHANVIEN
where PHONGBAN.TRPHG = NHANVIEN.MANV

-----C12

select HONV+ ' ' +TENLOT+ ' ' +TENNV as 'Họ và tên', DCHI from NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
where PHONGBAN.MAPHG = 4

-----C13

select TENDA, TENPHG, HONV+ ' ' +TENLOT+ ' ' +TENNV as 'Họ và tên', NG_NHANCHUC 
from NHANVIEN inner join PHONGBAN 
ON NHANVIEN.PHG = PHONGBAN.MAPHG 
inner join DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
where PHONGBAN.TRPHG = NHANVIEN.MANV and DCHI like '%Tp Quảng Ngãi'

-----C14

select HONV+ ' ' +TENLOT+ ' ' +TENNV as 'Họ và tên', TENTN as 'Tên người thân' 
from NHANVIEN inner join THANNHAN ON NHANVIEN.MANV = THANNHAN.MA_NVIEN
where NHANVIEN.PHAI = N'Nữ'

-----C15

select NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV as 'Họ và tên nhân viên', QL.HONV+ ' ' + QL.TENLOT + ' ' + QL.TENNV as 'Họ và tên quản lí'
	from NHANVIEN NV,NHANVIEN QL
	where NV.MA_NQL = QL.MANV

-----C16

select HONV+ ' ' + TENLOT + ' ' + TENNV as 'Họ và tên' 
from NHANVIEN inner join DEAN ON NHANVIEN.PHG = DEAN.PHONG
where DEAN.TENDA= 'Xây dựng nhà máy chế biến thủy sản'

-----C17

select TENDA as 'Tên đề án'
from NHANVIEN inner join DEAN ON NHANVIEN.PHG = DEAN.PHONG
where NHANVIEN.HONV = N'Trần' and NHANVIEN.TENLOT = N'Thanh' and NHANVIEN.TENNV = N'Tâm'