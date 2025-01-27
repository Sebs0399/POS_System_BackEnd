CREATE DATABASE POS_system;
GO

USE POS_system;
GO

CREATE TABLE Companies (
    CompanyId INT PRIMARY KEY IDENTITY(1,1),
    CompanyName NVARCHAR(100) NOT NULL,
    NIT NVARCHAR(50) NOT NULL, -- NIT o equivalente
    Address NVARCHAR(255),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Branches (
    BranchId INT PRIMARY KEY IDENTITY(1,1),
    CompanyId INT NOT NULL,
    BranchName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Phone NVARCHAR(15),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (CompanyId) REFERENCES Companies(CompanyId)
);
GO

CREATE TABLE Roles (
    RoleId INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    RoleId INT NOT NULL,
    BranchId INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE Products (
    ProductId INT PRIMARY KEY IDENTITY(1,1),
    BranchId INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(15),
    Address NVARCHAR(255),
    BranchId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE Invoices (
    InvoiceId INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL, -- Relación con la tabla Customer
    InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
    UserId INT NOT NULL, -- Usuario que realizó la factura
    TotalAmount DECIMAL(10,2) NOT NULL,
    BranchId INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1, 
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE Sales (
    SaleId INT PRIMARY KEY IDENTITY(1,1),
    InvoiceId INT NOT NULL, -- Factura asociada
    SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
    BranchId INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1, 
    FOREIGN KEY (InvoiceId) REFERENCES Invoices(InvoiceId),
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE SaleDetails (
    SaleDetailId INT PRIMARY KEY IDENTITY(1,1),
    SaleId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Total DECIMAL(10,2) NOT NULL, -- Calculado como Quantity * Price
    IsActive BIT NOT NULL DEFAULT 1, 
    FOREIGN KEY (SaleId) REFERENCES Sales(SaleId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
GO

CREATE TABLE InventoryMovements (
    MovementId INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT NOT NULL,
    UserId INT NOT NULL,
    MovementType NVARCHAR(50) NOT NULL, -- Ejemplo: 'Ingreso', 'Salida'
    Quantity INT NOT NULL,
    MovementDate DATETIME NOT NULL DEFAULT GETDATE(),
    Comments NVARCHAR(255),
    BranchId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);
GO

CREATE TABLE Reports (
    ReportId INT PRIMARY KEY IDENTITY(1,1),
    ReportName NVARCHAR(100) NOT NULL,
    ReportType NVARCHAR(50) NOT NULL, -- Ejemplo: 'Ventas', 'Inventario', etc.
    GeneratedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedBy INT NOT NULL, -- Usuario que generó el reporte
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserId)
);
GO

-- Insertar datos iniciales
-- Insertar roles predeterminados
INSERT INTO Roles (RoleName, IsActive) VALUES 
('Administrador', 1),
('Vendedor', 1);
GO

-- Insertar una empresa inicial
INSERT INTO Companies (CompanyName, NIT, Address, Phone, Email, IsActive) VALUES 
('Empresa Demo', '123456789-0', 'Calle 123 #45-67', '3001234567', 'demo@empresa.com', 1);
GO

-- Insertar una sucursal inicial
INSERT INTO Branches (CompanyId, BranchName, Address, Phone, IsActive) VALUES 
(1, 'Sucursal Principal', 'Calle 123 #45-67', '3001234567', 1);
GO

-- Insertar un usuario administrador inicial
INSERT INTO Users (UserName, PasswordHash, FullName, RoleId, BranchId, IsActive) VALUES 
('admin', HASHBYTES('SHA2_256', 'admin123'), 'Administrador del sistema', 1, 1, 1);
GO

-- Insertar un reporte inicial (Ejemplo)
INSERT INTO Reports (ReportName, ReportType, GeneratedAt, IsActive, CreatedBy) VALUES
('Reporte de Ventas Enero 2025', 'Ventas', GETDATE(), 1, 1);
GO
