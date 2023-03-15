---1.
CREATE PROCEDURE spTangLuong
AS
BEGIN
    UPDATE NhanVien
    SET Luong = Luong * 1.1
END;

EXEC spTangLuong;
---2.
ALTER TABLE NHANVIEN
ADD NgayNghiHuu DATE;

CREATE PROCEDURE spNghiHuu
AS
BEGIN
    UPDATE NHANVIEN
    SET NgayNghiHuu = DATEADD(day, 100, GETDATE())
    WHERE (Phai = 'Nam' AND DATEDIFF(year, NgSinh, GETDATE()) >= 60)
    OR (Phai = 'Nu' AND DATEDIFF(year, NgSinh, GETDATE()) >= 55)
END;
EXEC spNghiHuu;
---3. 
CREATE PROCEDURE spXemDeAn @DDiemDA NVARCHAR(255)
AS
BEGIN
    SELECT * FROM DeAn
    WHERE DDiemDA = @DDiemDA
END;
EXEC spXemDeAn @DDiemDA = N'<địa điểm>';
---4.
CREATE PROCEDURE spCapNhatDeAn @diadiem_cu NVARCHAR(255), @diadiem_moi NVARCHAR(255)
AS
BEGIN
    UPDATE DeAn
    SET DDiemDA = @diadiem_moi
    WHERE DDiemDA = @diadiem_cu
END;
EXEC spCapNhatDeAn @diadiem_cu = N'<địa điểm cũ>', @diadiem_moi = N'<địa điểm mới>';
---5.
CREATE PROCEDURE spThemDA
   @TenDa NVARCHAR(15),
    @MaDA int,
   @DDiemDA NVARCHAR(50),
   @MaPhg INT
 
AS
BEGIN
   SET NOCOUNT ON;
   INSERT INTO DEAN (TenDA, MaDA,DDiemDA)
   VALUES (@TENDA,@MADA,@DDiemDA);
END;
---6.
CREATE PROCEDURE spThemDA
    @MaDA INT,
    @TenDA NVARCHAR(50),
    @DDiemDA NVARCHAR(255),
    @MaPhg INT
AS
BEGIN
    IF EXISTS (SELECT * FROM DEAN WHERE MaDA = @MaDA)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM PHONGBAN WHERE MaPhg = @MaPhg)
    BEGIN
        RAISERROR ('Mã phòng không tồn tại', 16, 1);
        RETURN;
    END

    INSERT INTO DEAN (MaDA, TenDA, DDiemDA, MaPhg)
    VALUES (@MaDA, @TenDA, @DDiemDA, @MaPhg)
END
-- Trường hợp hợp lệ:
EXEC spThemDA 5, 'Đề án A', 'Mô tả cho Đề án A', 5;

-- Trường hợp không hợp lệ: Mã đề án đã tồн tại
EXEC spThemDA 1, 'Đề án B', 'Mô tả cho Đề án B', 1;

-- Trường hợp không hợp lệ: Mã phòng ban không tồн tại
EXEC spThemDA 2

---7.
CREATE PROCEDURE spXoaDeAn
    @MaDA INT
AS
BEGIN
    IF EXISTS (SELECT * FROM PHANCONG WHERE MaDA = @MaDA)
    BEGIN
        PRINT 'Không thể xóa đề án này vì nó đã được phân công';
        RETURN;
    END

    DELETE FROM DEAN WHERE MaDA = @MaDA;
END
---8.
CREATE PROCEDURE spXoaDA
    @MaDA INT
AS
BEGIN
    IF EXISTS (SELECT * FROM PHANCONG WHERE MaDA = @MaDA)
    BEGIN
        DELETE FROM PHANCONG WHERE MaDA = @MaDA;
    END

    DELETE FROM DEAN WHERE MaDA = @MaDA;
END
---9.
CREATE PROCEDURE spTongGioLamViec
    @MaNV INT,
    @TongGioLamViec INT OUTPUT
AS
BEGIN
    SELECT @TongGioLamViec = SUM(ThoiGian) FROM PHANCONG WHERE MaNV = @MaNV;
END
DECLARE @KetQua INT;
EXEC spTongGioLamViec 1, @KetQua OUTPUT;
SELECT @KetQua AS TongGioLamViec;
---10.
CREATE PROCEDURE spTongTien
    @MaNV INT
AS
BEGIN
    DECLARE @Luong INT;
    DECLARE @LuongDeAn INT;
    DECLARE @TongTien INT;

    SELECT @Luong = Luong FROM NHANVIEN WHERE MaNV = @MaNV;
    SELECT @LuongDeAn = SUM(ThoiGian) * 100000 FROM PHANCONG WHERE MaNV = @MaNV;
    SET @TongTien = @Luong + ISNULL(@LuongDeAn, 0);

    PRINT 'Tổng tiền phải trả cho nhân viên ' + CAST(@MaNV AS NVARCHAR(10)) + ' là ' + CAST(@TongTien AS NVARCHAR(20)) + ' đồng';
END
EXEC spTongTien 333;

---11.
CREATE PROCEDURE spThemPhanCong
    @MaDA INT,
    @MaNV INT,
    @ThoiGian INT
AS
BEGIN
    IF @ThoiGian <= 0
    BEGIN
        PRINT 'Thời gian phải là một số dương';
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM DEAN WHERE MaDA = @MaDA)
    BEGIN
        PRINT 'Mã đề án không tồn tại trong bảng DEAN';
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MaNV = @MaNV)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng NHANVIEN';
        RETURN;
    END

    INSERT INTO PHANCONG(MaDA, MaNV, ThoiGian) VALUES (@MaDA, @MaNV, @ThoiGian);
END
EXEC spThemPhanCong 1, 2, 3;