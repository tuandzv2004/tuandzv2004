-- Tạo bảng Loai
CREATE TABLE Loai (
    MaLoai NVARCHAR(10) PRIMARY KEY,
    TenLoai NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(MAX) NULL
);
ALTER TABLE Loai
ADD SoLuong INT DEFAULT 0;
-- Tạo bảng HangHoa với khóa ngoại
CREATE TABLE HangHoa (
    MaHH NVARCHAR(10) PRIMARY KEY,
    TenHH NVARCHAR(50) NOT NULL,
    MaLoai NVARCHAR(10) NOT NULL,
    DonGia FLOAT NULL,
    NgaySX DATETIME NOT NULL,
    GiamGia FLOAT NOT NULL,
    SoLanXem INT NOT NULL,
    MoTa NVARCHAR(MAX) NULL,
    FOREIGN KEY (MaLoai) REFERENCES Loai(MaLoai)
);
-- Tạo bảng KhachHang
CREATE TABLE KhachHang (
    MaKH NVARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(200) NULL,
    GioiTinh BIT NOT NULL,
    NgaySinh DATETIME NOT NULL,
    Email NVARCHAR(100) NULL,
    DienThoai NVARCHAR(15) NULL,
    HieuLuc BIT NOT NULL,
    VaiTro INT NOT NULL
);
ALTER TABLE KhachHang
ADD PhuongThuc NVARCHAR(20) NULL;

ALTER TABLE KhachHang
ADD CONSTRAINT DF_GioiTinh DEFAULT 'Không xác định' FOR GioiTinh;

ALTER TABLE KhachHang
ALTER COLUMN GioiTinh NVARCHAR(10) NULL; -- Thay đổi thành cho phép NULL

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'KhachHang';



-- Drop the CHECK constraint for PhuongThuc if it exists
ALTER TABLE KhachHang
DROP CONSTRAINT CK_PhuongThuc;  -- Use the correct name of the constraint if it differs

-- Drop the PhuongThuc column
ALTER TABLE KhachHang
DROP COLUMN PhuongThuc;




ALTER TABLE KhachHang
DROP COLUMN HieuLuc;

ALTER TABLE KhachHang
DROP COLUMN VaiTro;



CREATE TABLE HoaDon (
    MaHD NVARCHAR(10) PRIMARY KEY,
    MaKH NVARCHAR(10) NOT NULL,
    NgayDat DATETIME NOT NULL,
    NgayCan DATETIME NULL,
    NgayGiao DATETIME NULL,
    PhiVanChuyen FLOAT NOT NULL,
    MaTrangThai NVARCHAR(10) NOT NULL,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
CREATE TABLE NhanVien (
    MaNV NVARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(200) NOT NULL,
    GioiTinh BIT NOT NULL,
    NgaySinh DATETIME NOT NULL
);

-- Tạo bảng PhanCong với khóa ngoại
CREATE TABLE PhanCong (
    MaPC NVARCHAR(10) PRIMARY KEY,
    MaNV NVARCHAR(10) NOT NULL,
    NgayPhan DATETIME NOT NULL,
    MaHD NVARCHAR(10) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);
-- Tạo bảng ChiTietHD với khóa ngoại
CREATE TABLE ChiTietHD (
    MaCT NVARCHAR(10) PRIMARY KEY,
    MaHD NVARCHAR(10) NOT NULL,
    MaHH NVARCHAR(10) NOT NULL,
    DonGia FLOAT NOT NULL,
    SoLuong INT NOT NULL,
    GiamGia FLOAT NOT NULL,
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)
);

-- Tạo view vChiTietHoaDon

-- Tạo bảng ChuDe
CREATE TABLE ChuDe (
    MaCD NVARCHAR(10) PRIMARY KEY,
    TenCD NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(200) NULL
);

-- Tạo bảng GopY với khóa ngoại
CREATE TABLE GopY (
    MaGY NVARCHAR(10) PRIMARY KEY,
    MaCD NVARCHAR(10) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayGY DATE NOT NULL,
    MaKH NVARCHAR(10) NULL,
    CanTraLoi BIT NOT NULL,
    NoiDungTL NVARCHAR(MAX) NULL,
    NgayTL DATE NULL,
    FOREIGN KEY (MaCD) REFERENCES ChuDe(MaCD),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Tạo bảng HoaDon với khóa ngoại



-- Tạo bảng NhanVien

ALTER TABLE HangHoa
ADD Anh NVARCHAR(255);
CREATE VIEW vChiTietHoaDon AS 
SELECT cthd.*, hh.TenHH
FROM ChiTietHD cthd 
JOIN HangHoa hh ON hh.MaHH = cthd.MaHH;

INSERT INTO Loai (MaLoai, TenLoai, MoTa,SoLuong) VALUES
    ('L01', N'Cafe', N'Các loại đồ uống từ cà phê.',10),
    ('L02', N'Sinh tố và nước ép', N'Các loại sinh tố và nước ép trái cây tươi ngon.',10),
    ('L03', N'Tra và trà sữa', N'Các loại trà và trà sữa, thơm ngon, thanh mát.',10),
    ('L04', N'Kem', N'Các loại kem ngọt mát, hấp dẫn.',10),
    ('L05', N'Salad và đồ ăn nhẹ', N'Các loại salad và món ăn nhẹ ngọt, bổ dưỡng.',10);
INSERT INTO HangHoa (MaHH, TenHH, MaLoai, DonGia, NgaySX, GiamGia, SoLanXem, MoTa) VALUES
    ('HH01', N'Cà phê đen', 'L01', 30000, '2024-01-15', 0, 150, N'Cà phê đen nguyên chất, đậm đà.'),
    ('HH02', N'Cà phê sữa', 'L01', 35000, '2024-02-10', 0, 200, N'Cà phê pha với sữa đặc, ngọt dịu.'),
    ('HH03', N'Cà phê đá', 'L01', 28000, '2024-03-05', 0, 180, N'Cà phê đen với đá mát lạnh.'),
    ('HH04', N'Espresso', 'L01', 45000, '2024-04-20', 0, 220, N'Cà phê espresso đậm đà, đặc trưng Ý.'),
    ('HH05', N'Americano', 'L01', 40000, '2024-05-18', 0, 210, N'Cà phê pha loãng với hương vị nhẹ nhàng.'),
    ('HH06', N'Latte', 'L01', 50000, '2024-06-10', 0, 250, N'Cà phê pha với sữa tươi, béo ngọt.'),
    ('HH07', N'Cappuccino', 'L01', 55000, '2024-07-22', 0, 300, N'Cà phê với bọt sữa mềm mịn.'),
    ('HH08', N'Mocha', 'L01', 52000, '2024-08-30', 0, 190, N'Cà phê kết hợp vị sô cô la.'),
    ('HH09', N'Macchiato', 'L01', 53000, '2024-09-15', 0, 230, N'Cà phê với lớp sữa bọt béo ngọt.'),
    ('HH10', N'Cà phê truyền thống', 'L01', 30000, '2024-10-01', 0, 170, N'Cà phê Việt Nam đậm đà, truyền thống.'),
	('HH11', N'Nước ép cam', 'L02', 40000, '2024-01-10', 0, 120, N'Nước ép cam tươi nguyên chất, giàu vitamin C.'),
    ('HH12', N'Nước ép táo', 'L02', 45000, '2024-01-15', 0, 100, N'Nước ép táo tươi, thanh mát.'),
    ('HH13', N'Nước ép dâu', 'L02', 50000, '2024-02-20', 0, 150, N'Nước ép dâu tươi ngọt ngào.'),
    ('HH14', N'Nước ép dưa hấu', 'L02', 38000, '2024-03-05', 0, 180, N'Nước ép dưa hấu tươi mát lạnh.'),
    ('HH15', N'Sinh tố xoài', 'L02', 55000, '2024-04-15', 0, 200, N'Sinh tố xoài tươi béo ngọt.'),
    ('HH16', N'Sinh tố dâu', 'L02', 60000, '2024-05-10', 0, 170, N'Sinh tố dâu tươi béo mịn.'),
    ('HH17', N'Sinh tố bơ', 'L02', 65000, '2024-06-01', 0, 220, N'Sinh tố bơ giàu dinh dưỡng.'),
    ('HH18', N'Nước ép cà rốt', 'L02', 42000, '2024-06-20', 0, 130, N'Nước ép cà rốt tươi tốt cho sức khỏe.'),
    ('HH19', N'Nước ép dứa', 'L02', 48000, '2024-07-05', 0, 160, N'Nước ép dứa tươi mát lạnh.'),
    ('HH20', N'Sinh tố chuối', 'L02', 52000, '2024-08-10', 0, 140, N'Sinh tố chuối béo ngọt, giàu năng lượng.'),
    ('HH21', N'Trà xanh', 'L03', 30000, '2024-01-10', 0, 150, N'Trà xanh tươi mát, thanh khiết.'),
    ('HH22', N'Trà đen', 'L03', 25000, '2024-01-15', 0, 140, N'Trà đen đậm đà, hương vị đặc trưng.'),
    ('HH23', N'Trà sữa truyền thống', 'L03', 40000, '2024-02-10', 0, 200, N'Trà sữa truyền thống, ngọt ngào và béo ngậy.'),
    ('HH24', N'Trà sữa matcha', 'L03', 45000, '2024-02-15', 0, 220, N'Trà sữa matcha tươi, thanh mát.'),
    ('HH25', N'Trá sữa hoa quả', 'L03', 50000, '2024-03-05', 0, 180, N'Trá sữa kết hợp hoa quả tươi ngon.'),
    ('HH26', N'Trá sữa caramel', 'L03', 52000, '2024-03-10', 0, 200, N'Trá sữa caramel béo ngậy, ngọt ngào.'),
    ('HH27', N'Trá sữa dâu', 'L03', 55000, '2024-04-20', 0, 150, N'Trá sữa dâu thơm ngon, tươi mát.'),
    ('HH28', N'Trá sữa socola', 'L03', 58000, '2024-05-18', 0, 210, N'Trá sữa socola đậm vị, béo ngậy.'),
    ('HH29', N'Trá sữa trà xanh', 'L03', 60000, '2024-06-01', 0, 250, N'Trá sữa trà xanh thanh khiết, ngọt ngào.'),
    ('HH30', N'Trá sữa bạc hà', 'L03', 62000, '2024-06-10', 0, 230, N'Trá sữa bạc hà mát lạnh, sảng khoái.'),
	('HH31', N'Kem vanilla', 'L04', 25000, '2024-01-10', 0, 150, N'Kem vanilla thơm ngon, mềm mịn.'),
    ('HH32', N'Kem socola', 'L04', 30000, '2024-01-15', 0, 140, N'Kem socola đậm đà, ngọt ngào.'),
    ('HH33', N'Kem dâu', 'L04', 35000, '2024-02-10', 0, 200, N'Kem dâu tươi ngon, chua ngọt.'),
    ('HH34', N'Kem matcha', 'L04', 40000, '2024-02-15', 0, 220, N'Kem matcha thanh mát, giàu dinh dưỡng.'),
    ('HH35', N'Kem trà xanh', 'L04', 30000, '2024-03-05', 0, 180, N'Kem trà xanh thơm ngon, mát lạnh.'),
    ('HH36', N'Kem chuối', 'L04', 35000, '2024-03-10', 0, 150, N'Kem chuối ngọt ngào, béo thơm.'),
    ('HH37', N'Kem caramel', 'L04', 40000, '2024-04-20', 0, 210, N'Kem caramel béo ngậy, ngọt ngào.'),
    ('HH38', N'Kem dừa', 'L04', 45000, '2024-05-18', 0, 250, N'Kem dừa tươi mát, thơm lừng.'),
    ('HH39', N'Kem bạc hà', 'L04', 38000, '2024-06-01', 0, 230, N'Kem bạc hà mát lạnh, sảng khoái.'),
    ('HH40', N'Kem trái cây hỗn hợp', 'L04', 50000, '2024-06-10', 0, 300, N'Kem trái cây hỗn hợp tươi ngon, mát lạnh.'),
	('HH41', N'Salad trái cây', 'L05', 50000, '2024-01-10', 0, 150, N'Salad trái cây tươi ngon, bổ dưỡng.'),
    ('HH42', N'Salad rau xanh', 'L05', 45000, '2024-01-15', 0, 140, N'Salad rau xanh giòn tươi, thanh mát.'),
    ('HH43', N'Salad gà', 'L05', 70000, '2024-02-10', 0, 200, N'Salad gà ngọt ngào, thơm ngon.'),
    ('HH44', N'Salad trứng', 'L05', 60000, '2024-02-15', 0, 220, N'Salad trứng giàu dinh dưỡng, béo ngậy.'),
    ('HH45', N'Salad cá hồi', 'L05', 80000, '2024-03-05', 0, 180, N'Salad cá hồi tươi ngon, tốt cho sức khỏe.'),
    ('HH46', N'Bánh quy chocolate', 'L05', 20000, '2024-03-10', 0, 150, N'Bánh quy chocolate ngọt ngào, giòn tan.'),
    ('HH47', N'Bánh ngọt dâu', 'L05', 25000, '2024-04-20', 0, 210, N'Bánh ngọt dâu tươi ngon, ngọt dịu.'),
    ('HH48', N'Bánh kem trái cây', 'L05', 70000, '2024-05-18', 0, 250, N'Bánh kem trái cây mát lạnh, hấp dẫn.'),
    ('HH49', N'Mứt trái cây', 'L05', 30000, '2024-06-01', 0, 230, N'Mứt trái cây tự nhiên, ngọt ngào.'),
    ('HH50', N'Bánh mì ngọt', 'L05', 25000, '2024-06-10', 0, 300, N'Bánh mì ngọt mềm mại, thơm ngon.');


SELECT * FROM HangHoa;
MERGE INTO HangHoa AS target
USING (VALUES
    ('HH01', 'ca-phe-den.jpg'),
    ('HH02', 'ca-phe-sua.jpg'),
    ('HH03', 'ca-phe-da.jpg'),
    ('HH04', 'espresso.jpg'),
    ('HH05', 'americano.jpg'),
    ('HH06', 'latte.jpg'),
    ('HH07', 'cappuccino.jpg'),
    ('HH08', 'mocha.jpg'),
    ('HH09', 'macchiato.jpg'),
    ('HH10', 'ca-phe-truyen-thong.jpg'),
    ('HH11', 'nuoc-ep-cam.jpg'),
    ('HH12', 'nuoc-ep-tao.jpg'),
    ('HH13', 'nuoc-ep-dau.jpg'),
    ('HH14', 'nuoc-ep-dua-hau.jpg'),
    ('HH15', 'sinh-to-xoai.jpg'),
    ('HH16', 'sinh-to-dau.jpg'),
    ('HH17', 'sinh-to-bo.jpg'),
    ('HH18', 'nuoc-ep-ca-rot.jpg'),
    ('HH19', 'nuoc-ep-dua.jpg'),
    ('HH20', 'sinh-to-chuoi.jpg'),
    ('HH21', 'tra-xanh.jpg'),
    ('HH22', 'tra-den.jpg'),
    ('HH23', 'tra-sua-truyen-thong.jpg'),
    ('HH24', 'tra-sua-matcha.jpg'),
    ('HH25', 'tra-sua-hoa-qua.jpg'),
    ('HH26', 'tra-sua-caramel.jpg'),
    ('HH27', 'tra-sua-dau.jpg'),
    ('HH28', 'tra-sua-socola.jpg'),
    ('HH29', 'tra-sua-tra-xanh.jpg'),
    ('HH30', 'tra-sua-bac-ha.jpg'),
    ('HH31', 'kem-vanilla.jpg'),
    ('HH32', 'kem-socola.jpg'),
    ('HH33', 'kem-dau.jpg'),
    ('HH34', 'kem-matcha.jpg'),
    ('HH35', 'kem-tra-xanh.jpg'),
    ('HH36', 'kem-chuoi.jpg'),
    ('HH37', 'kem-caramel.jpg'),
    ('HH38', 'kem-dua.jpg'),
    ('HH39', 'kem-bac-ha.jpg'),
    ('HH40', 'kem-trai-cay-hon-hop.jpg'),
    ('HH41', 'salad-trai-cay.jpg'),
    ('HH42', 'salad-rau-xanh.jpg'),
    ('HH43', 'salad-ga.jpg'),
    ('HH44', 'salad-trung.jpg'),
    ('HH45', 'salad-ca-hoi.jpg'),
    ('HH46', 'banh-quy-chocolate.jpg'),
    ('HH47', 'banh-ngot-dau.jpg'),
    ('HH48', 'banh-kem-trai-cay.jpg'),
    ('HH49', 'mut-trai-cay.jpg'),
    ('HH50', 'banh-mi-ngot.jpg')
) AS source (MaHH, Anh)
ON target.MaHH = source.MaHH
WHEN MATCHED THEN
    UPDATE SET target.Anh = source.Anh;


	CREATE TABLE ChiTietGioHang (
    MaCTGH INT PRIMARY KEY IDENTITY(1,1),  -- Mã chi tiết giỏ hàng, tự động tăng
    MaKH NVARCHAR(10) NOT NULL,                      -- Mã khách hàng
    MaHH NVARCHAR(10) NOT NULL,            -- Mã sản phẩm
    HH01 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH01
    HH02 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH02
    HH03 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH03
    HH04 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH04
    HH05 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH05
    HH06 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH06
    HH07 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH07
    HH08 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH08
    HH09 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH09
    HH10 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH10
    HH11 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH11
    HH12 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH12
    HH13 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH13
    HH14 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH14
    HH15 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH15
    HH16 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH16
    HH17 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH17
    HH18 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH18
    HH19 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH19
    HH20 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH20
    HH21 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH21
    HH22 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH22
    HH23 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH23
    HH24 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH24
    HH25 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH25
    HH26 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH26
    HH27 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH27
    HH28 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH28
    HH29 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH29
    HH30 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH30
    HH31 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH31
    HH32 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH32
    HH33 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH33
    HH34 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH34
    HH35 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH35
    HH36 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH36
    HH37 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH37
    HH38 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH38
    HH39 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH39
    HH40 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH40
    HH41 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH41
    HH42 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH42
    HH43 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH43
    HH44 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH44
    HH45 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH45
    HH46 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH46
    HH47 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH47
    HH48 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH48
    HH49 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH49
    HH50 INT DEFAULT 0,                    -- Số lượng cho sản phẩm HH50
    PhuongThuc NVARCHAR(20) NOT NULL,      -- Phương thức (Ăn tại đây, Mang về, Giao hàng)
    DiaChi NVARCHAR(255),                   -- Địa chỉ (có thể null nếu không áp dụng)
    TongTien DECIMAL(18, 2) DEFAULT 0,     -- Tổng tiền (tính số lượng sản phẩm * giá)
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),  -- Khóa ngoại tham chiếu đến bảng khách hàng
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)     -- Khóa ngoại tham chiếu đến bảng sản phẩm
);

ALTER TABLE ChiTietGioHang
ADD CreatedAt DATETIME DEFAULT GETDATE() NOT NULL;


CREATE TRIGGER TinhTongTien
ON ChiTietGioHang
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaCTGH INT, @tong DECIMAL(18, 2);

    -- Loop through each row in the INSERTED table
    DECLARE row_cursor CURSOR FOR 
    SELECT MaCTGH
    FROM INSERTED;

    OPEN row_cursor;
    FETCH NEXT FROM row_cursor INTO @MaCTGH;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate total price for the current row
        SET @tong = 
            (
                (ISNULL((SELECT HH01 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH01')) +
                (ISNULL((SELECT HH02 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH02')) +
                (ISNULL((SELECT HH03 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH03')) +
                (ISNULL((SELECT HH04 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH04')) +
                (ISNULL((SELECT HH05 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH05')) +
                (ISNULL((SELECT HH06 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH06')) +
                (ISNULL((SELECT HH07 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH07')) +
                (ISNULL((SELECT HH08 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH08')) +
                (ISNULL((SELECT HH09 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH09')) +
                (ISNULL((SELECT HH10 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH10')) +
                (ISNULL((SELECT HH11 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH11')) +
                (ISNULL((SELECT HH12 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH12')) +
                (ISNULL((SELECT HH13 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH13')) +
                (ISNULL((SELECT HH14 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH14')) +
                (ISNULL((SELECT HH15 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH15')) +
                (ISNULL((SELECT HH16 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH16')) +
                (ISNULL((SELECT HH17 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH17')) +
                (ISNULL((SELECT HH18 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH18')) +
                (ISNULL((SELECT HH19 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH19')) +
                (ISNULL((SELECT HH20 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH20')) +
                (ISNULL((SELECT HH21 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH21')) +
                (ISNULL((SELECT HH22 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH22')) +
                (ISNULL((SELECT HH23 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH23')) +
                (ISNULL((SELECT HH24 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH24')) +
                (ISNULL((SELECT HH25 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH25')) +
                (ISNULL((SELECT HH26 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH26')) +
                (ISNULL((SELECT HH27 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH27')) +
                (ISNULL((SELECT HH28 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH28')) +
                (ISNULL((SELECT HH29 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH29')) +
                (ISNULL((SELECT HH30 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH30')) +
                (ISNULL((SELECT HH31 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH31')) +
                (ISNULL((SELECT HH32 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH32')) +
                (ISNULL((SELECT HH33 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH33')) +
                (ISNULL((SELECT HH34 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH34')) +
                (ISNULL((SELECT HH35 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH35')) +
                (ISNULL((SELECT HH36 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH36')) +
                (ISNULL((SELECT HH37 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH37')) +
                (ISNULL((SELECT HH38 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH38')) +
                (ISNULL((SELECT HH39 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH39')) +
                (ISNULL((SELECT HH40 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH40')) +
                (ISNULL((SELECT HH41 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH41')) +
                (ISNULL((SELECT HH42 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH42')) +
                (ISNULL((SELECT HH43 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH43')) +
                (ISNULL((SELECT HH44 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH44')) +
                (ISNULL((SELECT HH45 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH45')) +
                (ISNULL((SELECT HH46 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH46')) +
                (ISNULL((SELECT HH47 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH47')) +
                (ISNULL((SELECT HH48 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH48')) +
                (ISNULL((SELECT HH49 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH49')) +
                (ISNULL((SELECT HH50 FROM INSERTED WHERE MaCTGH = @MaCTGH), 0) * (SELECT ISNULL(DonGia, 0) FROM HangHoa WHERE MaHH = 'HH50'))
            );

        -- Update TongTien for the current MaCTGH
        UPDATE ChiTietGioHang
        SET TongTien = @tong
        WHERE MaCTGH = @MaCTGH;

        -- Move to the next row
        FETCH NEXT FROM row_cursor INTO @MaCTGH;
    END;

    CLOSE row_cursor;
    DEALLOCATE row_cursor;
END;
