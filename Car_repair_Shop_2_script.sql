USE [Car_repair_shop]
GO
/****** Object:  UserDefinedFunction [dbo].[FmVehConditionCheck1]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  Table [dbo].[Invoices_History]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  Table [dbo].[Invoices]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  Table [dbo].[Vehicles]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  View [dbo].[CarsVin]    Script Date: 13.01.2020 20:18:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[CarsVin]
as
select [ProductionDate],[Brand],[Model],[VIN]
from [dbo].[Vehicles]
GO
/****** Object:  Table [dbo].[SparePartsUsedHistory]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  Table [dbo].[SparePartsUsed]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  Table [dbo].[Mechanics]    Script Date: 13.01.2020 20:18:57 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UniquePhoneCon] UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Repairs]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  StoredProcedure [dbo].[getCountEngineType]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  StoredProcedure [dbo].[getRepairsMilageAndEngine2]    Script Date: 13.01.2020 20:18:57 ******/
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
/****** Object:  StoredProcedure [dbo].[getTurbochargerRepairsOnly]    Script Date: 13.01.2020 20:18:57 ******/
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
