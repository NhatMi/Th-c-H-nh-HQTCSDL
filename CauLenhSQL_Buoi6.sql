--1. Cho biết danh sách các nhân viên có ít nhất một thân nhân
SELECT MANV, TENNV
FROM NHANVIEN
WHERE ( SELECT COUNT (*)
   FROM THANNHAN
   WHERE THANNHAN.MA_NVIEN=NHANVIEN.MANV) >0
--2. Cho biết danh sách các nhân viên không có thân nhân nào
SELECT MANV, TENNV
FROM NHANVIEN 
WHERE NOT EXISTS  (SELECT *
   FROM THANNHAN 
   WHERE THANNHAN.MA_NVIEN=NHANVIEN.MANV)
--3. Cho biết họ tên các nhân viên có trên 2 thân nhân.
SELECT HONV,TENLOT, TENNV
FROM NHANVIEN
WHERE ( SELECT COUNT (*)
   FROM THANNHAN
   WHERE THANNHAN.MA_NVIEN=NHANVIEN.MANV) >=2
--4. Cho biết họ tên những trưởng phòng có ít nhất một thân nhân.
SELECT HONV,TENLOT, TENNV
FROM NHANVIEN
WHERE MANV IN
	(SELECT TRPHG
	FROM PHONGBAN
	WHERE PHONGBAN.TRPHG=NHANVIEN.MANV)
			AND MANV NOT IN
	(SELECT MANV
	FROM THANNHAN
	WHERE THANNHAN.MA_NVIEN=NHANVIEN.MANV)
--6. Cho biết họ tên các nhân viên phòng Quản lý có mức lương trên mức lương trung bình của phòng Quản lý.
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) 
FROM NHANVIEN
WHERE NHANVIEN.LUONG > (SELECT AVG(NHANVIEN.LUONG)
						FROM NHANVIEN, PHONGBAN
						WHERE NHANVIEN.PHG = PHONGBAN.MAPHG AND
							PHONGBAN.TENPHG = N'Quản lý')
--7. Cho biết họ tên nhân viên có mức lương trên mức lương trung bình của phòng mà nhân viên đó đang làm việc
SELECT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) 
FROM NHANVIEN
WHERE NHANVIEN.LUONG > (SELECT AVG(NHANVIEN.LUONG)
						FROM NHANVIEN, PHONGBAN
						WHERE NHANVIEN.PHG = PHONGBAN.MAPHG)
--8. Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất.
SELECT PHONGBAN.TENPHG, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên trưởng phòng của phòng ban đông nhân viên nhất'
	FROM NHANVIEN, PHONGBAN
	WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND
		  PHONGBAN.MAPHG = (SELECT TOP 1 PHONGBAN.MAPHG
							FROM NHANVIEN, PHONGBAN
							WHERE NHANVIEN.PHG = PHONGBAN.MAPHG
							GROUP BY PHONGBAN.MAPHG
							ORDER BY COUNT (NHANVIEN.PHG) DESC
							)
--9. Cho biết danh sách các đề án mà nhân viên có mã là 456 chưa tham gia.
	SELECT DEAN.MADA
	FROM DEAN
	WHERE DEAN.MADA NOT IN (SELECT PHANCONG.MADA
							FROM PHANCONG
							WHERE PHANCONG.MA_NVIEN = '456'
							)
--10. Danh sách nhân viên gồm mã nhân viên, họ tên và địa chỉ của những nhân viên không sống tại TP Quảng Ngãi nhưng làm việc cho một đề án ở TP Quảng Ngãi.
SELECT DISTINCT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
	FROM NHANVIEN, DEAN, DIADIEM_PHG
	WHERE NHANVIEN.PHG = DEAN.PHONG AND
		  NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND
		  DEAN.DDIEM_DA LIKE '%TP.QuảngNgãi' AND
		  DIADIEM_PHG.DIADIEM NOT LIKE '%TP.QuảngNgãi'
--11. Tìm họ tên và địa chỉ của các nhân viên làm việc cho một đề án ở một địa điểm nhưng lại không sống tại địa điểm đó.
SELECT DISTINCT (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV) AS 'Họ tên nhân viên', NHANVIEN.DCHI
	FROM NHANVIEN, DEAN, DIADIEM_PHG
	WHERE NHANVIEN.PHG = DEAN.PHONG AND
		  NHANVIEN.PHG = DIADIEM_PHG.MAPHG AND
		  DEAN.DDIEM_DA IN (SELECT DEAN.DDIEM_DA
							FROM DEAN
							) AND
		  DIADIEM_PHG.DIADIEM NOT LIKE DEAN.DDIEM_DA
--12. Cho biết danh sách các mã đề án có: nhân công với họ là Lê hoặc có người trưởng phòng chủ trì đề án với họ là Lê.
SELECT PHANCONG.MADA
FROM NHANVIEN, PHANCONG
WHERE NHANVIEN.MANV = PHANCONG.MA_NVIEN AND NHANVIEN.HONV = N'Lê'
UNION 
SELECT DEAN.MADA
FROM NHANVIEN, PHONGBAN, DEAN
WHERE NHANVIEN.MANV = PHONGBAN.TRPHG AND PHONGBAN.MAPHG = DEAN.PHONG 
	AND NHANVIEN.HONV = N'Lê'
--13. Liệt kê danh sách các đề án mà cả hai nhân viên có mã số 123 và 789 cùng làm.
SELECT DISTINCT d.MADA
FROM DEAN d, PHANCONG pc1, PHANCONG pc2 
WHERE d.MADA = pc1.MADA AND pc1.MADA = pc2.MADA 
AND pc1.MA_NVIEN = 123 AND pc2.MA_NVIEN = 789;

--14. Liệt kê danh sách các đề án mà cả hai nhân viên Đinh Bá Tiến và Trần Thanh Tâm cùng làm

SELECT DISTINCT d.MADA
FROM DEAN d, PHANCONG pc1, PHANCONG pc2, NHANVIEN nv1, NHANVIEN nv2
WHERE d.MADA = pc1.MADA AND pc1.MADA = pc2.MADA AND pc1.MA_NVIEN = nv1.MANV AND pc2.MA_NVIEN = nv2.MANV
AND nv1.TENNV = 'Tiến' AND nv2.TENNV = 'Tâm';

--15. Danh sách những nhân viên (bao gồm mã nhân viên, họ tên, phái) làm việc trong mọi đề án của công ty
SELECT NHANVIEN.MANV, NHANVIEN.PHAI, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV) AS 'Họ tên nhân viên'
FROM NHANVIEN, PHANCONG
WHERE NHANVIEN.MANV = PHANCONG.MA_NVIEN
GROUP BY NHANVIEN.MANV, NHANVIEN.PHAI, (NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' '+ NHANVIEN.TENNV)
HAVING COUNT(NHANVIEN.MANV) >= (SELECT COUNT(DEAN.MADA)
								FROM DEAN)