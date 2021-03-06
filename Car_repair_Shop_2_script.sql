USE [Car_repair_shop]
GO
/****** Object:  UserDefinedFunction [dbo].[FmVehConditionCheck1]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FmVehConditionCheck1](@vmileage int)
returns varchar(50)
begin
	declare @vConditionDiscription varchar(50)
		select @vConditionDiscription =
			case  
				when @vmileage <= 200000 then 'Vehicle mileage is not higher than 200 000 km'
				when @vmileage > 200000 then 'Vehicle mileage is exceeds or equals 200 000 km'
			else 'Unknown Condition'
		end
	return @vConditionDiscription
end
GO
/****** Object:  Table [dbo].[Invoices_History]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices_History](
	[Id_invoice] [int] NOT NULL,
	[Id_repair] [int] NULL,
	[NetAmount] [money] NULL,
	[PaymentStatus] [varchar](30) NULL,
	[NIP_TaxIdNo] [varchar](10) NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[Id_invoice] [int] IDENTITY(1,1) NOT NULL,
	[Id_repair] [int] NULL,
	[NetAmount] [money] NULL,
	[PaymentStatus] [varchar](30) NULL,
	[NIP_TaxIdNo] [varchar](10) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_invoice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Invoices_History] )
)
GO
/****** Object:  Table [dbo].[Vehicles]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicles](
	[Id_vehicle] [int] IDENTITY(1,1) NOT NULL,
	[VIN] [char](17) NULL,
	[ProductionDate] [date] NULL,
	[RegistrationNo] [char](7) NULL,
	[Brand] [varchar](20) NULL,
	[Model] [varchar](20) NULL,
	[EngineNo] [varchar](20) NULL,
	[EngineType] [varchar](100) NULL,
	[BodyType] [nchar](10) NULL,
	[Color] [varchar](20) NULL,
	[FuelType] [varchar](20) NULL,
 CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED 
(
	[Id_vehicle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CarsVin]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[CarsVin]
as
select [ProductionDate],[Brand],[Model],[VIN]
from [dbo].[Vehicles]
GO
/****** Object:  Table [dbo].[SparePartsUsedHistory]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SparePartsUsedHistory](
	[Id_spare] [int] NOT NULL,
	[type] [varchar](50) NULL,
	[discription] [varchar](255) NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SparePartsUsed]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SparePartsUsed](
	[Id_spare] [int] IDENTITY(1,1) NOT NULL,
	[type] [varchar](50) NULL,
	[discription] [varchar](255) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_spare] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[SparePartsUsedHistory] )
)
GO
/****** Object:  Table [dbo].[Mechanics]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mechanics](
	[Id_mechanic] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](25) NULL,
	[LastName] [varchar](25) NULL,
	[Phone] [varchar](9) NULL,
	[Email] [varchar](50) NULL,
	[Industry] [varchar](50) NULL,
	[Licenses] [varchar](50) NULL,
 CONSTRAINT [PK_Mechanics] PRIMARY KEY CLUSTERED 
(
	[Id_mechanic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Repairs]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Repairs](
	[Id_repair] [int] IDENTITY(1,1) NOT NULL,
	[Id_vehicle] [int] NULL,
	[Id_mechanic] [int] NULL,
	[ReceptionDate] [date] NULL,
	[Mileage] [int] NULL,
	[Condition] [varchar](255) NULL,
	[RepairStatus] [varchar](30) NULL,
	[RepairDate] [date] NULL,
	[RepairType] [varchar](30) NULL,
	[RepairDescription] [varchar](255) NULL,
 CONSTRAINT [PK_Repairs] PRIMARY KEY CLUSTERED 
(
	[Id_repair] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Invoices] ON 

INSERT [dbo].[Invoices] ([Id_invoice], [Id_repair], [NetAmount], [PaymentStatus], [NIP_TaxIdNo], [ValidFrom], [ValidTo]) VALUES (1, 8, 3000.0000, N'On Hold', N'7123280000', CAST(N'2020-01-05T14:14:46.5570147' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [dbo].[Invoices] ([Id_invoice], [Id_repair], [NetAmount], [PaymentStatus], [NIP_TaxIdNo], [ValidFrom], [ValidTo]) VALUES (2, 9, 3000.0000, N'On Hold', N'7123333444', CAST(N'2020-01-05T14:14:46.5570147' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [dbo].[Invoices] ([Id_invoice], [Id_repair], [NetAmount], [PaymentStatus], [NIP_TaxIdNo], [ValidFrom], [ValidTo]) VALUES (3, 10, 3500.0000, N'Closed', N'7123442211', CAST(N'2020-01-05T14:14:52.1415816' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [dbo].[Invoices] ([Id_invoice], [Id_repair], [NetAmount], [PaymentStatus], [NIP_TaxIdNo], [ValidFrom], [ValidTo]) VALUES (4, 11, 4800.0000, N'closed', N'7123282311', CAST(N'2020-01-05T14:14:46.5570147' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Invoices] OFF
INSERT [dbo].[Invoices_History] ([Id_invoice], [Id_repair], [NetAmount], [PaymentStatus], [NIP_TaxIdNo], [ValidFrom], [ValidTo]) VALUES (3, 10, 3500.0000, N'closed', N'7123442211', CAST(N'2020-01-05T14:14:46.5570147' AS DateTime2), CAST(N'2020-01-05T14:14:52.1415816' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Mechanics] ON 

INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (1, N'Phil', N'Badovsky', N'604552214', N'philbadovsky@carrepairone.com', N'body repair', N'Welding License Level 2')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (2, N'Lucas', N'Jimenez', N'604552322', N'Lucash@yahoo.com', N'body repair', N'Welding License Level 1')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (3, N'Mateo', N'Ortiz', N'688715714', N'mortiz1980@hotmail.com', N'auto electrician', N'Vehicle Systems Maintenance Level 1')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (4, N'Martin', N'Soreto', N'688715780', N'msoretto193@carrepairone.com', N'auto electrician', N'Vehicle Systems Maintenance Level 2')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (5, N'John', N'Sanchez', N'688715122', N'johsanches@carrepairone.com', N'motor mechanic', N'Light Vehicle Maintenance and Repair Level 2')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (6, N'Liam', N'Johnson', N'899521333', N'liamjohnson@carrepairone.com', N'motor mechanic', N'Light Vehicle Maintenance and Repair Level 2')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (7, N'Gustavo', N'Rodriquez', N'899521203', N'gustavorod@carrepairone.com', N'motor mechanic', N'Diploma in Vehicle Technology Level 3')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (8, N'Tony', N'Rivera', N'604609321', N'tonyriviera@carrepairone.com', N'motor mechanic', N'Diploma in Vehicle Technology Level 3')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (9, N'Lucia', N'Young', N'698528820', N'luciayoung@carrepairone.com', N'motor mechanic', N'Light Vehicle Maintenance and Repair Level 2')
INSERT [dbo].[Mechanics] ([Id_mechanic], [FirstName], [LastName], [Phone], [Email], [Industry], [Licenses]) VALUES (10, N'Olivia', N'Perez', N'789365214', N'operez@carrepairone.com', N'electrician & diagnostic', N'Vehicle Systems Maintenance Level 3')
SET IDENTITY_INSERT [dbo].[Mechanics] OFF
SET IDENTITY_INSERT [dbo].[Repairs] ON 

INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (1, 1, 1, CAST(N'2019-05-05' AS Date), 85230, N'lots of scratches', N'closed', CAST(N'2019-05-02' AS Date), N'body work', N'body work, spot painting, rear bumper replacment')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (2, 1, 2, CAST(N'2019-09-26' AS Date), 86008, N'front bumper cracked', N'closed', CAST(N'2019-10-01' AS Date), N'body work', N'front bumper replacment')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (3, 2, 2, CAST(N'2019-10-15' AS Date), 51400, N'rear bumper, lights cracked', N'closed', CAST(N'2019-10-21' AS Date), N'body work', N'replacement of rear bumper, lights + bodywork')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (4, 3, 2, CAST(N'2019-10-26' AS Date), 33208, N'left doors scratches and dents', N'closed', CAST(N'2019-11-01' AS Date), N'body work', N'bodywork of left doors + fender replacement')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (5, 21, 5, CAST(N'2017-11-01' AS Date), 122450, N'Good', N'closed', CAST(N'2017-11-09' AS Date), N'mechanical work', N'turbocharger regeneration + suspension replacement')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (6, 22, 5, CAST(N'2017-08-13' AS Date), 112245, N'Good', N'closed', CAST(N'2017-08-20' AS Date), N'mechanical work', N'common rail pump regeneration')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (7, 23, 5, CAST(N'2017-03-16' AS Date), 162031, N'Good', N'closed', CAST(N'2017-03-20' AS Date), N'mechanical work', N'suspension replacement')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (8, 24, 5, CAST(N'2017-03-27' AS Date), 102090, N'Good', N'closed', CAST(N'2017-04-02' AS Date), N'mechanical work', N'complete breaks replacement')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (9, 4, 6, CAST(N'2018-05-20' AS Date), 289090, N'Good', N'closed', CAST(N'2018-05-24' AS Date), N'mechanical work + body work', N'mask painting, transmission repair + oil change, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (10, 5, 6, CAST(N'2018-03-30' AS Date), 349202, N'Good', N'closed', CAST(N'2018-03-24' AS Date), N'mechanical work + body work', N'mask painting, turbocharger regeneration, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (11, 6, 6, CAST(N'2018-03-10' AS Date), 182290, N'Good', N'closed', CAST(N'2018-03-15' AS Date), N'mechanical work', N'suspension repair, turbocharger regeneration, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (12, 7, 6, CAST(N'2018-03-10' AS Date), 260390, N'Good', N'closed', CAST(N'2018-03-15' AS Date), N'mechanical work', N'complete common rail injection system regeneration, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (13, 8, 7, CAST(N'2018-04-01' AS Date), 290345, N'Good', N'closed', CAST(N'2018-04-05' AS Date), N'mechanical work', N'complete common rail injection system regeneration, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (14, 9, 7, CAST(N'2019-09-27' AS Date), 340005, N'Good', N'closed', CAST(N'2019-10-01' AS Date), N'mechanical work', N'complete clutch kit with dual-mass flywheel replacement, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (15, 10, 7, CAST(N'2019-11-07' AS Date), 360005, N'Good', N'closed', CAST(N'2019-11-01' AS Date), N'mechanical work', N'complete clutch kit with dual-mass flywheel replacement, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (16, 11, 7, CAST(N'2019-08-12' AS Date), 311045, N'Good', N'closed', CAST(N'2019-08-06' AS Date), N'mechanical work', N'breaks repair, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (17, 12, 8, CAST(N'2019-09-01' AS Date), 287078, N'Good', N'closed', CAST(N'2019-08-26' AS Date), N'mechanical work', N'complete front breaks replacement, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (18, 13, 8, CAST(N'2019-02-27' AS Date), 234567, N'Good', N'closed', CAST(N'2019-02-23' AS Date), N'mechanical work', N'common rail pump regeneration, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (19, 14, 8, CAST(N'2019-03-22' AS Date), 264500, N'Good', N'closed', CAST(N'2019-03-18' AS Date), N'mechanical work', N'common rail pump regeneration, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (20, 15, 8, CAST(N'2019-06-03' AS Date), 244600, N'Good', N'closed', CAST(N'2019-05-23' AS Date), N'mechanical work', N'breaks repair, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (21, 16, 8, CAST(N'2019-08-08' AS Date), 244600, N'Good', N'closed', CAST(N'2019-08-03' AS Date), N'mechanical work', N'timing kit replacement, suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (22, 17, 9, CAST(N'2017-08-09' AS Date), 112500, N'Good', N'closed', CAST(N'2017-08-03' AS Date), N'mechanical work', N'suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (23, 18, 9, CAST(N'2017-10-02' AS Date), 116560, N'Good', N'closed', CAST(N'2017-09-23' AS Date), N'mechanical work', N'complete breaks replacement, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (24, 19, 9, CAST(N'2017-11-01' AS Date), 122123, N'Good', N'closed', CAST(N'2017-10-27' AS Date), N'mechanical work', N'complete breaks replacement, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (25, 20, 9, CAST(N'2017-11-12' AS Date), 122123, N'Good', N'closed', CAST(N'2017-11-09' AS Date), N'mechanical work', N'turbocharger repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (26, 21, 10, CAST(N'2017-11-07' AS Date), 147890, N'Good', N'closed', CAST(N'2017-11-03' AS Date), N'computer diagnostic', N'computer errors erasement & diagnostic')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (27, 22, 10, CAST(N'2017-08-17' AS Date), 172220, N'Good', N'closed', CAST(N'2017-08-12' AS Date), N'computer diagnostic', N'diagnostic safety systems')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (28, 23, 1, CAST(N'2017-11-01' AS Date), 139220, N'left side scratches', N'closed', CAST(N'2017-11-10' AS Date), N'body work', N'left side painting + body work')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (29, 24, 1, CAST(N'2017-11-07' AS Date), 119340, N'right side scratches', N'closed', CAST(N'2017-11-11' AS Date), N'body work', N'right side painting + body work')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (30, 25, 1, CAST(N'2017-11-11' AS Date), 207140, N'front bumper cracked', N'closed', CAST(N'2017-11-13' AS Date), N'body work', N'front bumper and grill replacement')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (31, 26, 2, CAST(N'2017-11-02' AS Date), 187140, N'left door dent', N'closed', CAST(N'2017-11-04' AS Date), N'body work', N'left door body work')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (32, 27, 2, CAST(N'2017-11-03' AS Date), 187140, N'right door dent', N'closed', CAST(N'2017-11-05' AS Date), N'body work', N'right door body work')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (33, 28, 2, CAST(N'2017-11-05' AS Date), 187140, N'left side scratches', N'closed', CAST(N'2017-11-10' AS Date), N'body work', N'left side painting + body work')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (34, 29, 10, CAST(N'2017-10-02' AS Date), 234140, N'Good', N'closed', CAST(N'2017-10-04' AS Date), N'computer diagnostic', N'turbocharger failure diagnostics')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (35, 29, 5, CAST(N'2017-10-02' AS Date), 234140, N'Good', N'closed', CAST(N'2017-10-04' AS Date), N'mechanical work', N'turbocharger repair')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (36, 30, 5, CAST(N'2017-10-04' AS Date), 268151, N'Good', N'closed', CAST(N'2017-10-08' AS Date), N'mechanical work', N'suspension repair, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (37, 31, 5, CAST(N'2017-10-05' AS Date), 214196, N'Good', N'closed', CAST(N'2017-10-11' AS Date), N'mechanical work', N'complete breaks replacement, oil & filters change')
INSERT [dbo].[Repairs] ([Id_repair], [Id_vehicle], [Id_mechanic], [ReceptionDate], [Mileage], [Condition], [RepairStatus], [RepairDate], [RepairType], [RepairDescription]) VALUES (38, 32, 3, CAST(N'2017-10-01' AS Date), 204778, N'Good', N'closed', CAST(N'2017-10-06' AS Date), N'electrical system work', N'alternator replacement')
SET IDENTITY_INSERT [dbo].[Repairs] OFF
SET IDENTITY_INSERT [dbo].[SparePartsUsed] ON 

INSERT [dbo].[SparePartsUsed] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (1, N'turbocharger', N'suspension part', CAST(N'2020-01-01T14:30:25.6319047' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [dbo].[SparePartsUsed] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (2, N'turbocharger', N'suspension part 2', CAST(N'2020-01-01T14:31:37.5540187' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [dbo].[SparePartsUsed] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (3, N'fly wheel', N'suspension part 2', CAST(N'2020-01-01T14:32:24.1399925' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
SET IDENTITY_INSERT [dbo].[SparePartsUsed] OFF
INSERT [dbo].[SparePartsUsedHistory] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (1, N'suspension part', N'suspension part', CAST(N'2020-01-01T14:25:26.1409421' AS DateTime2), CAST(N'2020-01-01T14:30:25.6319047' AS DateTime2))
INSERT [dbo].[SparePartsUsedHistory] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (2, N'suspension part 2', N'suspension part 2', CAST(N'2020-01-01T14:31:18.4156984' AS DateTime2), CAST(N'2020-01-01T14:31:37.5540187' AS DateTime2))
INSERT [dbo].[SparePartsUsedHistory] ([Id_spare], [type], [discription], [ValidFrom], [ValidTo]) VALUES (3, N'suspension part 2', N'suspension part 2', CAST(N'2020-01-01T14:32:11.4029422' AS DateTime2), CAST(N'2020-01-01T14:32:24.1399925' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Vehicles] ON 

INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (1, N'TMBBEEF1200023Z35', CAST(N'2012-03-03' AS Date), N'WU1071J', N'Skoda', N'Superb', N'287F2012', N'2.0 TDI 160KM M6', N'Liftback  ', N'Silver', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (2, N'TMBBEEF1200098Z40', CAST(N'2012-03-03' AS Date), N'WU1090A', N'Skoda', N'Superb', N'287F2012', N'2.0 TDI 160KM M6', N'Liftback  ', N'Blue', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (3, N'TMBBEEF1200873Z42', CAST(N'2012-03-20' AS Date), N'WU1051E', N'Skoda', N'Superb', N'312F2012', N'2.0 TDI 180KM M6', N'Liftback  ', N'Black', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (4, N'TMBBEEF1200876Z40', CAST(N'2012-03-23' AS Date), N'WU1958U', N'Skoda', N'Superb', N'312F2012', N'2.0 TDI 180KM M6', N'Liftback  ', N'White', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (5, N'TMWWEEF1200688Z40', CAST(N'2014-04-20' AS Date), N'WU2240L', N'Skoda', N'Octavia', N'380F2014', N'1.6 TDI 120KM M6', N'Liftback  ', N'White', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (6, N'TMWWEEF1200670Z40', CAST(N'2014-01-08' AS Date), N'WU2440L', N'Skoda', N'Octavia', N'380F2014', N'1.6 TDI 120KM M6', N'Liftback  ', N'White', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (7, N'TMWWEEF1200239Z40', CAST(N'2013-08-03' AS Date), N'WU2891L', N'Skoda', N'Octavia', N'371F2013', N'1.6 TDI 120KM M6', N'Liftback  ', N'Silver', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (8, N'TMWWEEF1200234Z40', CAST(N'2013-08-06' AS Date), N'WU1212K', N'Skoda', N'Octavia', N'371F2013', N'1.6 TDI 120KM M6', N'Liftback  ', N'Green', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (9, N'EEXXHUK8800334G54', CAST(N'2016-08-06' AS Date), N'WU7854R', N'Hyundai', N'I40', N'EETF16700', N'1.6 CRDI 136KM M6', N'Wagon     ', N'White', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (10, N'EEXXHUK8800344G80', CAST(N'2016-08-09' AS Date), N'WU7880C', N'Hyundai', N'I40', N'EETF16700', N'1.6 CRDI 136KM M6', N'Wagon     ', N'Brown', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (11, N'EEXXHUK8800899GGA', CAST(N'2016-09-09' AS Date), N'WU7896R', N'Hyundai', N'I40', N'EETG44500', N'2.0 TURBO 202KM A6', N'Liftback  ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (12, N'EEXXHUK8800832GGA', CAST(N'2016-09-01' AS Date), N'WU7878S', N'Hyundai', N'I40', N'EETG44500', N'2.0 TURBO 202KM A6', N'Wagon     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (13, N'FEMAA80000220HVB4', CAST(N'2015-01-09' AS Date), N'WU7456D', N'Ford', N'Mondeo', N'FERFGG560', N'2.0 TDCI 180KM M6', N'Kombi     ', N'Silver', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (14, N'FEMAA800002260HVB', CAST(N'2015-04-03' AS Date), N'WU73450', N'Ford', N'Mondeo', N'FERFGG560', N'2.0 TDCI 180KM M6', N'Liftback  ', N'Silver', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (15, N'FEMAA80000123HVB4', CAST(N'2015-04-21' AS Date), N'WU73000', N'Ford', N'Mondeo', N'FERFBB560', N'2.0 ECOBOOST 220KM M6', N'Kombi     ', N'Silver', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (16, N'FEMAA80000126HVB4', CAST(N'2015-07-24' AS Date), N'WU74532', N'Ford', N'Mondeo', N'FERFBB564', N'1.6 ECOBOOST 180KM M6', N'Liftback  ', N'Black', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (17, N'4NPTT30000EU10126', CAST(N'2016-02-18' AS Date), N'WX80052', N'Hyundai', N'I20', N'20AMXC1067', N'1.2 MPI 5MT 75 KM', N'Hatchback ', N'Black', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (18, N'4NPTT30000EU10229', CAST(N'2016-04-08' AS Date), N'WX80090', N'Hyundai', N'I20', N'20AMXC1170', N'1.2 MPI 5MT 75 KM', N'Hatchback ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (19, N'4NPTT30000EU10345', CAST(N'2016-10-08' AS Date), N'WX80222', N'Hyundai', N'I20', N'20AFXC1170', N'1.0 T-GDI 5MT 100 KM', N'Hatchback ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (20, N'4NPTT30000EU116A4', CAST(N'2016-11-03' AS Date), N'WX80227', N'Hyundai', N'I20', N'20AFXA12X4', N'1.0 T-GDI 7DCT 100 KM', N'Hatchback ', N'Blue', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (21, N'5EPTT30000EU19807', CAST(N'2016-11-05' AS Date), N'WX23023', N'Hyundai', N'I30', N'30AFX11109', N'1.4 MPI 6MT 100KM', N'Hatchback ', N'Blue', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (22, N'5EPTT30000EU19905', CAST(N'2016-11-20' AS Date), N'WX23089', N'Hyundai', N'I30', N'30AFX11225', N'1.4 MPI 6MT 100KM', N'Hatchback ', N'Red', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (23, N'5EPTT30000EU03404', CAST(N'2016-02-20' AS Date), N'WX23112', N'Hyundai', N'I30', N'30SFX10855', N'1.6 CRDI 6MT 95KM', N'Wagon     ', N'Red', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (24, N'5EPTT30000EU03600', CAST(N'2016-08-20' AS Date), N'WX23442', N'Hyundai', N'I30', N'30SFX10980', N'1.6 CRDI 6MT 115KM', N'Wagon     ', N'Grey', N'Diesel')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (25, N'5EPTT30000EU02709', CAST(N'2016-03-09' AS Date), N'WX23920', N'Hyundai', N'I30', N'30BFT10228', N'1.4 T-GDI 6MT 140KM', N'Hatchback ', N'White sand', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (26, N'5EPTT30000EU02900', CAST(N'2016-03-22' AS Date), N'WX240MA', N'Hyundai', N'I30', N'30BFT10365', N'1.4 T-GDI 6MT 140KM', N'Wagon     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (27, N'1HBBGGJX162200708', CAST(N'2015-07-24' AS Date), N'WN74532', N'Ford', N'Focus', N'58VVBC1234', N'1.0 ECOBOOST 100KM M6', N'Hatchback ', N'Black', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (28, N'1HBBGGJX162210218', CAST(N'2015-09-28' AS Date), N'WN7443X', N'Ford', N'Focus', N'58VVBC1104', N'1.0 ECOBOOST 125KM M6', N'Kombi     ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (29, N'1HBBGGJX162220129', CAST(N'2015-02-08' AS Date), N'WN4009X', N'Ford', N'Focus', N'58VVEC1190', N'1.0 ECOBOOST 125KM M6', N'Hatchback ', N'Blue', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (30, N'1HBBGGJX162200929', CAST(N'2015-02-08' AS Date), N'WN4009X', N'Ford', N'Focus', N'58VVEC1224', N'1.0 ECOBOOST 125KM M6', N'Kombi     ', N'Grey', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (31, N'1HBBGGJX162240928', CAST(N'2015-12-08' AS Date), N'WN4223X', N'Ford', N'Focus', N'62VVXX4560', N'1.5 ECOBOOST 150KM M6', N'Kombi     ', N'Grey', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (32, N'1HBBGGJX162240968', CAST(N'2015-12-08' AS Date), N'WN4223X', N'Ford', N'Focus', N'62VVXX4560', N'1.5 ECOBOOST 150KM A6', N'Kombi     ', N'Dark blue', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (33, N'1HBBGGJX162241202', CAST(N'2015-10-10' AS Date), N'WN4300X', N'Ford', N'Focus', N'62VVXX6050', N'1.5 ECOBOOST 182KM M6', N'Kombi     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (34, N'1HBBGGJX162241506', CAST(N'2015-10-20' AS Date), N'WN4328X', N'Ford', N'Focus', N'62VVXX6890', N'1.5 ECOBOOST 182KM A6', N'Hatchback ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (35, N'1HDXGGJX162241556', CAST(N'2015-01-20' AS Date), N'WN7800E', N'Ford', N'Focus', N'82VTTX7080', N'1.5 ECOBLUE 95 KM M6', N'Hatchback ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (36, N'1HDXGGJX162242050', CAST(N'2015-02-24' AS Date), N'WN7833E', N'Ford', N'Focus', N'82VTTX7111', N'1.5 ECOBLUE 120 KM M6', N'Kombi     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (37, N'1HDXGGJX162242650', CAST(N'2015-03-11' AS Date), N'WN7841E', N'Ford', N'Focus', N'82VTTX7198', N'1.5 ECOBLUE 120 KM M6', N'Kombi     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (38, N'1HDXGGJX162242757', CAST(N'2015-04-13' AS Date), N'WN7842E', N'Ford', N'Focus', N'82VTTX7206', N'2.0 ECOBLUE 150 KM M6', N'Kombi     ', N'Black', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (39, N'1HDXGGJX162242959', CAST(N'2015-04-26' AS Date), N'WN7870E', N'Ford', N'Focus', N'82VTTX7334', N'2.0 ECOBLUE 150 KM M6', N'Kombi     ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (40, N'1HDXGGJX162243455', CAST(N'2015-06-20' AS Date), N'WN7890E', N'Ford', N'Focus', N'82VTTX7371', N'2.0 ECOBLUE 150 KM A6', N'Kombi     ', N'Black', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (41, N'JT4NNXRN000103660', CAST(N'2014-01-22' AS Date), N'WG1120H', N'Toyota', N'Corolla', N'772MPXX122', N'1.6 VVT-I 132 KM 6 M/T', N'Sedan     ', N'White', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (42, N'JT4NNXRN000104055', CAST(N'2014-02-28' AS Date), N'WG2020H', N'Toyota', N'Corolla', N'772MPXX442', N'1.6 VVT-I 132 KM 6 M/T', N'Sedan     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (43, N'JT4NNXRN000104700', CAST(N'2014-03-20' AS Date), N'WG2020H', N'Toyota', N'Corolla', N'772MPXX469', N'1.6 VVT-I 132 KM 6 M/T', N'Sedan     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (44, N'JT4NNXRN000105110', CAST(N'2014-03-24' AS Date), N'WG2070H', N'Toyota', N'Corolla', N'772MPXX501', N'1.6 VVT-I 132 KM 6 M/T', N'Sedan     ', N'Silver', N'Petrol')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (45, N'JE4EEXTH000122030', CAST(N'2015-03-24' AS Date), N'WG3001H', N'Toyota', N'Corolla', N'810EEXU210', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'White', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (46, N'JE4EEXTH000122800', CAST(N'2015-03-24' AS Date), N'WG3022H', N'Toyota', N'Corolla', N'810EEXU322', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'White', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (47, N'JE4EEXTH000123900', CAST(N'2015-03-26' AS Date), N'WG3023H', N'Toyota', N'Corolla', N'810EEXU345', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Red', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (48, N'JE4EEXTH000122210', CAST(N'2015-04-09' AS Date), N'WG3029H', N'Toyota', N'Corolla', N'810EEXU233', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Bronze', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (49, N'JE4EEXTH000134450', CAST(N'2015-04-09' AS Date), N'WG3300H', N'Toyota', N'Corolla', N'810EEXU402', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Bronze', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (50, N'JE4EEXTH000134494', CAST(N'2015-04-13' AS Date), N'WG3303H', N'Toyota', N'Corolla', N'810EEXU422', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Red', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (51, N'JE4EEXTH000134545', CAST(N'2015-04-09' AS Date), N'WG3304H', N'Toyota', N'Corolla', N'810EEXU437', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Silver', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (52, N'JE4EEXTH000135647', CAST(N'2015-05-18' AS Date), N'WG3344H', N'Toyota', N'Corolla', N'810EEXU467', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Gold', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (53, N'JE4EEXTH000135040', CAST(N'2015-05-22' AS Date), N'WG3349H', N'Toyota', N'Corolla', N'810EEXU478', N'1.8 HYBRID 122 KM E-CVT', N'Sedan     ', N'Gold', N'Hybryd')
INSERT [dbo].[Vehicles] ([Id_vehicle], [VIN], [ProductionDate], [RegistrationNo], [Brand], [Model], [EngineNo], [EngineType], [BodyType], [Color], [FuelType]) VALUES (54, N'TMWWEEF1200234Z49', CAST(N'2013-10-10' AS Date), N'WU8084H', N'Hyundai', N'I40', N'EXTTG5504', N'2.0 TURBO 202 KM A6', N'Wagon     ', N'Silver', N'Petrol')
SET IDENTITY_INSERT [dbo].[Vehicles] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UniquePhoneCon]    Script Date: 13.01.2020 20:34:03 ******/
ALTER TABLE [dbo].[Mechanics] ADD  CONSTRAINT [UniquePhoneCon] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_Repairs] FOREIGN KEY([Id_repair])
REFERENCES [dbo].[Repairs] ([Id_repair])
GO
ALTER TABLE [dbo].[Invoices] CHECK CONSTRAINT [FK_Invoices_Repairs]
GO
ALTER TABLE [dbo].[Repairs]  WITH CHECK ADD  CONSTRAINT [FK_Repairs_Mechanics] FOREIGN KEY([Id_mechanic])
REFERENCES [dbo].[Mechanics] ([Id_mechanic])
GO
ALTER TABLE [dbo].[Repairs] CHECK CONSTRAINT [FK_Repairs_Mechanics]
GO
ALTER TABLE [dbo].[Repairs]  WITH CHECK ADD  CONSTRAINT [FK_Repairs_Vehicles] FOREIGN KEY([Id_vehicle])
REFERENCES [dbo].[Vehicles] ([Id_vehicle])
GO
ALTER TABLE [dbo].[Repairs] CHECK CONSTRAINT [FK_Repairs_Vehicles]
GO
ALTER TABLE [dbo].[Mechanics]  WITH CHECK ADD  CONSTRAINT [CheckAddEmailCon] CHECK  (([Email] like '%_@_%'))
GO
ALTER TABLE [dbo].[Mechanics] CHECK CONSTRAINT [CheckAddEmailCon]
GO
ALTER TABLE [dbo].[Mechanics]  WITH CHECK ADD  CONSTRAINT [CheckAddPhoneCon] CHECK  (([Phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Mechanics] CHECK CONSTRAINT [CheckAddPhoneCon]
GO
/****** Object:  StoredProcedure [dbo].[getCountEngineType]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getCountEngineType]
@vEngineDiscription varchar(30),
@vEngineTypeCount int output
as
	select @vEngineTypeCount=count(v.EngineType)
	from 
	[dbo].[Vehicles] v
	where v.EngineType like '%' + @vEngineDiscription + '%'
	order by count(v.EngineType) desc
	return
GO
/****** Object:  StoredProcedure [dbo].[getRepairsMilageAndEngine2]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[getRepairsMilageAndEngine2]
@vmillage int,
@vEngineDis varchar(20)
as
select v.Brand, v.Model, v.ProductionDate, v.EngineType, v.FuelType,
r.Mileage, r.RepairType, r.RepairDescription
from 
[dbo].[Repairs] r
join
[dbo].[Vehicles] v on r.[Id_vehicle]=v.Id_vehicle
where r.Mileage >= @vmillage and v.EngineType like '%' + @vEngineDis + '%'
GO
/****** Object:  StoredProcedure [dbo].[getTurbochargerRepairsOnly]    Script Date: 13.01.2020 20:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[getTurbochargerRepairsOnly]
as
select v.Brand, v.Model, v.Vin, v.ProductionDate, v.EngineNo, v.EngineType, v.FuelType,
r.Mileage, r.ReceptionDate, r.RepairDate, r.RepairDescription 
from 
[dbo].[Repairs] r
join
[dbo].[Vehicles] v on r.[Id_vehicle]=v.Id_vehicle
where r.[RepairDescription] like '%turbocharger%';
GO
