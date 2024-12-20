USE [master]
GO
/****** Object:  Database [Hospital]    Script Date: 09.11.2024 19:38:40 ******/
CREATE DATABASE [Hospital]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Hospital', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Hospital.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Hospital_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Hospital_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Hospital].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Hospital] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Hospital] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Hospital] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Hospital] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Hospital] SET ARITHABORT OFF 
GO
ALTER DATABASE [Hospital] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Hospital] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Hospital] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Hospital] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Hospital] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Hospital] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Hospital] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Hospital] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Hospital] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Hospital] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Hospital] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Hospital] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Hospital] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Hospital] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Hospital] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Hospital] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Hospital] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Hospital] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Hospital] SET  MULTI_USER 
GO
ALTER DATABASE [Hospital] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Hospital] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Hospital] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Hospital] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Hospital] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Hospital]
GO
/****** Object:  DatabaseRole [db_secure]    Script Date: 09.11.2024 19:38:40 ******/
CREATE ROLE [db_secure]
GO
/****** Object:  DatabaseRole [db_doc]    Script Date: 09.11.2024 19:38:40 ******/
CREATE ROLE [db_doc]
GO
/****** Object:  DatabaseRole [db_admin]    Script Date: 09.11.2024 19:38:40 ******/
CREATE ROLE [db_admin]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [db_secure]
GO
ALTER ROLE [db_datareader] ADD MEMBER [db_doc]
GO
ALTER ROLE [db_owner] ADD MEMBER [db_admin]
GO
/****** Object:  Schema [administrator]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [administrator]
GO
/****** Object:  Schema [db_admin]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [db_admin]
GO
/****** Object:  Schema [db_doc]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [db_doc]
GO
/****** Object:  Schema [db_secure]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [db_secure]
GO
/****** Object:  Schema [doctor]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [doctor]
GO
/****** Object:  Schema [security]    Script Date: 09.11.2024 19:38:40 ******/
CREATE SCHEMA [security]
GO
/****** Object:  UserDefinedFunction [dbo].[Calculator]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Calculator]
(@Opd1 bigint,
@Opd2 bigint,
@Oprt char(1) = '*')
RETURNS bigint
AS
BEGIN
DECLARE @Result bigint
SET @Result = CASE @Oprt
WHEN '+' THEN @Opd1 + @Opd2
WHEN '-' THEN @Opd1 - @Opd2
WHEN '*' THEN @Opd1 * @Opd2
WHEN '/' THEN @Opd1 / @Opd2
ELSE 0
END
Return @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[CountOperationsInOneDay]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CountOperationsInOneDay] (@DateToCheck DATE)
RETURNS INT
AS
BEGIN
    DECLARE @OperationCount INT;

    SELECT @OperationCount = COUNT(*)
    FROM Operations
    WHERE OperationDate = @DateToCheck;

    RETURN @OperationCount;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[ParseStr]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ParseStr] (@String nvarchar(500))
RETURNS @table TABLE
(Number int IDENTITY (1,1) NOT NULL,
Substr nvarchar (30))
AS
BEGIN
DECLARE @Str1 nvarchar(500), @Pos int,
@Count int, @PosCount int
SET @Count = 0
SET @PosCount = 1
SET @Str1 = @String
WHILE @Count < LEN(@Str1)
	BEGIN
	SET @Pos = CHARINDEX(' ', @Str1)
	IF @Pos > 0
		BEGIN
		SET @Count = @Count + 1
		INSERT INTO @table
		VALUES (SUBSTRING (@Str1, 1, @Pos))
		SET @Str1 = REPLACE(@Str1, SUBSTRING (@Str1, 1, @Pos), '')
		END
	ELSE
		BEGIN
		INSERT INTO @table
		VALUES (@Str1)
		BREAK
		END
	END
RETURN
END
GO
/****** Object:  Table [dbo].[Doctors]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
	[DoctorID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorSurname] [nvarchar](20) NOT NULL,
	[DoctorFirstName] [nvarchar](20) NOT NULL,
	[DoctorPatronymic] [nvarchar](20) NULL,
	[EmploymentDate] [date] NOT NULL,
	[Post] [nvarchar](50) NOT NULL,
	[ScientificTitle] [nvarchar](50) NULL,
	[Adress] [nvarchar](max) NOT NULL,
	[WorkExperience]  AS (datediff(year,[EmploymentDate],getdate())),
 CONSTRAINT [PK_Doctors] PRIMARY KEY CLUSTERED 
(
	[DoctorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctors_test]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors_test](
	[DoctorID] [int] NOT NULL,
	[Surname] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[Patronymic] [nvarchar](20) NULL,
	[EmploymentDate] [date] NOT NULL,
	[Post] [nvarchar](50) NOT NULL,
	[ScientificTitle] [nvarchar](50) NULL,
	[Adress] [nvarchar](max) NOT NULL,
	[WorkExperience]  AS (datediff(year,[EmploymentDate],getdate())),
 CONSTRAINT [PK__Doctors_te__69DF5139865B3020] PRIMARY KEY CLUSTERED 
(
	[DoctorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalHistory]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalHistory](
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[DoctorID] [int] NOT NULL,
	[Diagnosis] [nvarchar](50) NOT NULL,
	[DateOfIllness] [date] NOT NULL,
	[DateOfCure] [date] NOT NULL,
	[TreatmentType] [nvarchar](50) NOT NULL,
	[OperationID] [int] NOT NULL,
 CONSTRAINT [PK_MedicalHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operations]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operations](
	[OperationID] [int] IDENTITY(1,1) NOT NULL,
	[OperationDescription] [nvarchar](max) NOT NULL,
	[DoctorID] [int] NOT NULL,
	[OperationDate] [date] NOT NULL,
	[PatientID] [int] NOT NULL,
	[OperationResult] [nvarchar](20) NOT NULL,
	[OperationImage] [nvarchar](50) NULL,
 CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED 
(
	[OperationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[PatientSurname] [nvarchar](20) NOT NULL,
	[PatientFirstName] [nvarchar](20) NOT NULL,
	[PatientPatronymic] [nvarchar](20) NULL,
	[Adress] [nvarchar](max) NOT NULL,
	[City] [nvarchar](20) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[Age]  AS (datediff(year,[BirthDate],getdate())),
 CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients_test]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients_test](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[Surname] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[Patronymic] [nvarchar](20) NULL,
	[Adress] [nvarchar](max) NOT NULL,
	[City] [nvarchar](20) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK__Patients__4216A28D8698CF8B] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TreatmentSheet]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TreatmentSheet](
	[TreatmentID] [int] IDENTITY(1,1) NOT NULL,
	[HistoryID] [int] NOT NULL,
	[DateOfTreatment] [date] NOT NULL,
	[Medicines] [nvarchar](50) NOT NULL,
	[Temperature] [decimal](3, 1) NOT NULL,
	[Pressure] [nvarchar](10) NOT NULL,
	[PatientsCondition] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TreatmentSheet] PRIMARY KEY CLUSTERED 
(
	[TreatmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[FirstView]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FirstView] AS
SELECT DoctorID, Surname, FirstName, Patronymic, Post, WorkExperience, ScientificTitle
FROM Doctors
WHERE WorkExperience < 5 AND ScientificTitle IS NULL;
GO
/****** Object:  View [dbo].[SecondView]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SecondView] AS
SELECT FirstView.Surname AS 'Surname врача', Post, WorkExperience, 
ScientificTitle, Patients.Surname AS 'Surname пациента', Patients.FirstName AS 'FirstName пациента', 
Patients.Patronymic AS 'Patronymic пациента', Diagnosis, TreatmentType
FROM FirstView
JOIN MedicalHistory ON FirstView.DoctorID = MedicalHistory.DoctorID
JOIN Patients ON MedicalHistory.OperationID = Patients.PatientID
GO
/****** Object:  View [dbo].[FourthView]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FourthView]
AS
SELECT        dbo.FirstView.Surname AS [Surname врача], dbo.FirstView.Post, dbo.FirstView.WorkExperience, dbo.FirstView.ScientificTitle, dbo.Patients.Surname AS [Surname пациента], dbo.Patients.FirstName AS [FirstName пациента], 
                         dbo.Patients.Patronymic AS [Patronymic пациента], dbo.MedicalHistory.Diagnosis, dbo.MedicalHistory.TreatmentType
FROM            dbo.FirstView INNER JOIN
                         dbo.MedicalHistory ON dbo.FirstView.DoctorID = dbo.MedicalHistory.DoctorID INNER JOIN
                         dbo.Patients ON dbo.MedicalHistory.OperationID = dbo.Patients.PatientID
GO
/****** Object:  UserDefinedFunction [dbo].[DoctorsPerformedOperationsOTD]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DoctorsPerformedOperationsOTD] (@OperationDate DATE)
RETURNS TABLE AS
RETURN
	SELECT
		Doctors.Surname AS 'Surname врача',
		OperationDescription,
		OperationDate,
		Patients.Surname AS 'Surname пациента',
		Patients.FirstName AS 'FirstName пациента',
		Patients.Patronymic AS 'Patronymic пациента',
		OperationResult
	FROM
		Doctors, Patients, Operations
	WHERE
		(Doctors.DoctorID = Operations.DoctorID AND Patients.PatientID = Operations.OperationID) AND OperationDate = @OperationDate;
GO
/****** Object:  UserDefinedFunction [dbo].[DynamicTable]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DynamicTable] (@City nvarchar(20))
RETURNS TABLE
AS
RETURN SELECT PatientID, Surname, Adress, City, Gender, Age
FROM Patients
WHERE City = @City
GO
/****** Object:  View [dbo].[ThirdView]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ThirdView] AS
SELECT DoctorID, Surname, FirstName, Patronymic, Post, WorkExperience, ScientificTitle
FROM Doctors
WHERE WorkExperience > 5 AND ScientificTitle IS NOT NULL;
GO
SET IDENTITY_INSERT [dbo].[Doctors] ON 

INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (1, N'Козлов', N'Игорь', N'Владимирович', CAST(N'2019-11-22' AS Date), N'Онколог', N'Доктор медицинских наук', N'ул. Солнечная, д. 7')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (2, N'Лебедева', N'Марина', N'Алексеевна', CAST(N'2022-04-26' AS Date), N'Невролог', N'Кандидат медицинских наук', N'пр. Мира, д. 22')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (3, N'Смирнов', N'Дмитрий', N'Петрович', CAST(N'2023-01-19' AS Date), N'Педиатр', NULL, N'пер. Зеленый, д. 15')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (4, N'Никитин', N'Артем', N'Сергеевич', CAST(N'2020-01-22' AS Date), N'Офтальмолог', N'Кандидат медицинских наук', N'ул. Гагарина, д. 3')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (5, N'Павлов', N'Кирилл', N'Александрович', CAST(N'2019-11-24' AS Date), N'Проктолог', NULL, N'площадь Центральная, д. 1')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (6, N'Кузнецова', N'Ольга', N'Игоревна', CAST(N'2020-06-19' AS Date), N'Дерматолог', NULL, N'ул. Цветочная, д. 12')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (7, N'Васильев', N'Александр', NULL, CAST(N'2024-03-18' AS Date), N'Отоларинголог', N'Доктор медицинских наук', N'пр. Советский, д. 9')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (8, N'Григорьева', N'Татьяна', N'Павловна', CAST(N'2022-11-20' AS Date), N'Стоматолог', NULL, N'пр. Ленинский, д. 4')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (9, N'Макаров', N'Никита', N'Васильевич', CAST(N'2018-03-02' AS Date), N'Травматолог', NULL, N'ул. Первомайская, д. 11')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (10, N'Антонова', N'Екатерина', N'Дмитриевна', CAST(N'2024-03-13' AS Date), N'Уролог', NULL, N'пр. Гагарина, д. 6')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (11, N'Смирнов', N'Андрей', N'Иванович', CAST(N'2018-05-10' AS Date), N'Хирург', N'Кандидат медицинских наук', N'пр. Лесной, д. 15')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (12, N'Петров', N'Николай', N'Петрович', CAST(N'2020-09-03' AS Date), N'Терапевт', N'Кандидат медицинских наук', N'ул. Центральная, д. 23')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (13, N'Иванова', N'Мария', N'Александровна', CAST(N'2017-07-15' AS Date), N'Невролог', N'Доктор медицинских наук', N'пл. Победы, д. 8')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (14, N'Соколов', N'Артем', N'Сергеевич', CAST(N'2016-11-20' AS Date), N'Ортопед', N'Кандидат медицинских наук', N'ул. Горького, д. 30')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (15, N'Зайцева', N'Екатерина', N'Игоревна', CAST(N'2019-04-02' AS Date), N'Гинеколог', N'Кандидат медицинских наук', N'пр. Солнечный, д. 12')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (16, N'Васильев', N'Александр', N'Дмитриевич', CAST(N'2015-08-12' AS Date), N'Кардиолог', N'Доктор медицинских наук', N'ул. Мира, д. 5')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (17, N'Кузнецова', N'Ольга', N'Владимировна', CAST(N'2017-02-28' AS Date), N'Офтальмолог', N'Кандидат медицинских наук', N'пл. Лесная, д. 17')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (18, N'Морозова', N'Ирина', N'Петровна', CAST(N'2020-11-05' AS Date), N'Уролог', N'Кандидат медицинских наук', N'ул. Садовая, д. 10')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (19, N'Иванов', N'Дмитрий', N'Алексеевич', CAST(N'2018-06-18' AS Date), N'Педиатр', N'Доктор медицинских наук', N'пр. Центральный, д. 25')
INSERT [dbo].[Doctors] ([DoctorID], [DoctorSurname], [DoctorFirstName], [DoctorPatronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (20, N'Козлова', N'Елена', N'Сергеевна', CAST(N'2021-01-10' AS Date), N'Отоларинголог', N'Кандидат медицинских наук', N'ул. Речная, д. 50')
SET IDENTITY_INSERT [dbo].[Doctors] OFF
GO
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (1, N'Козлов', N'Игорь', N'Владимирович', CAST(N'2019-11-22' AS Date), N'Онколог', N'Доктор медицинских наук', N'ул. Солнечная, д. 7')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (2, N'Лебедева', N'Марина', N'Алексеевна', CAST(N'2022-04-26' AS Date), N'Невролог', NULL, N'пр. Мира, д. 22')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (3, N'Смирнов', N'Дмитрий', N'Петрович', CAST(N'2023-01-19' AS Date), N'Педиатр', NULL, N'пер. Зеленый, д. 15')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (4, N'Никитин', N'Артем', N'Сергеевич', CAST(N'2020-01-22' AS Date), N'Офтальмолог', N'Кандидат медицинских наук', N'ул. Гагарина, д. 3')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (5, N'Павлов', N'Кирилл', N'Александрович', CAST(N'2019-11-24' AS Date), N'Проктолог', NULL, N'площадь Центральная, д. 1')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (6, N'Кузнецова', N'Ольга', N'Игоревна', CAST(N'2020-06-19' AS Date), N'Дерматолог', NULL, N'ул. Цветочная, д. 12')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (7, N'Васильев', N'Александр', NULL, CAST(N'2024-03-18' AS Date), N'Отоларинголог', N'Доктор медицинских наук', N'пр. Советский, д. 9')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (8, N'Григорьева', N'Татьяна', N'Павловна', CAST(N'2022-11-20' AS Date), N'Стоматолог', NULL, N'пр. Ленинский, д. 4')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (9, N'Павлов', N'Никита', N'Васильевич', CAST(N'2018-03-02' AS Date), N'Травматолог', NULL, N'ул. Первомайская, д. 11')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (10, N'Антонова', N'Екатерина', N'Дмитриевна', CAST(N'2024-03-13' AS Date), N'Уролог', NULL, N'пр. Гагарина, д. 6')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (11, N'Смирнов', N'Андрей', N'Иванович', CAST(N'2018-05-10' AS Date), N'Хирург', N'Кандидат медицинских наук', N'пр. Лесной, д. 15')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (12, N'Петров', N'Николай', N'Петрович', CAST(N'2020-09-03' AS Date), N'Терапевт', N'Кандидат медицинских наук', N'ул. Центральная, д. 23')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (13, N'Иванова', N'Мария', N'Александровна', CAST(N'2017-07-15' AS Date), N'Невролог', N'Доктор медицинских наук', N'пл. Победы, д. 8')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (14, N'Соколов', N'Артем', N'Сергеевич', CAST(N'2016-11-20' AS Date), N'Ортопед', N'Кандидат медицинских наук', N'ул. Горького, д. 30')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (15, N'Зайцева', N'Екатерина', N'Игоревна', CAST(N'2019-04-02' AS Date), N'Гинеколог', N'Кандидат медицинских наук', N'пр. Солнечный, д. 12')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (16, N'Васильев', N'Александр', N'Дмитриевич', CAST(N'2015-08-12' AS Date), N'Кардиолог', N'Доктор медицинских наук', N'ул. Мира, д. 5')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (17, N'Кузнецова', N'Ольга', N'Владимировна', CAST(N'2017-02-28' AS Date), N'Офтальмолог', N'Кандидат медицинских наук', N'пл. Лесная, д. 17')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (18, N'Морозова', N'Ирина', N'Петровна', CAST(N'2020-11-05' AS Date), N'Уролог', N'Кандидат медицинских наук', N'ул. Садовая, д. 10')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (19, N'Иванов', N'Дмитрий', N'Алексеевич', CAST(N'2018-06-18' AS Date), N'Педиатр', N'Доктор медицинских наук', N'пр. Центральный, д. 25')
INSERT [dbo].[Doctors_test] ([DoctorID], [Surname], [FirstName], [Patronymic], [EmploymentDate], [Post], [ScientificTitle], [Adress]) VALUES (20, N'Козлова', N'Елена', N'Сергеевна', CAST(N'2021-01-10' AS Date), N'Отоларинголог', N'Кандидат медицинских наук', N'ул. Речная, д. 50')
GO
SET IDENTITY_INSERT [dbo].[MedicalHistory] ON 

INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (1, 1, 1, N'Рак легкого', CAST(N'2023-02-10' AS Date), CAST(N'2023-02-15' AS Date), N'Стационарное', 1)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (2, 2, 3, N'Аритмия', CAST(N'2023-03-05' AS Date), CAST(N'2023-03-08' AS Date), N'Амбулаторное', 2)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (3, 5, 2, N'Мигрень', CAST(N'2023-04-20' AS Date), CAST(N'2023-05-02' AS Date), N'Стационарное', 3)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (4, 7, 5, N'Геморрой', CAST(N'2023-06-14' AS Date), CAST(N'2023-06-20' AS Date), N'Амбулаторное', 4)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (5, 9, 4, N'Конъюнктивит', CAST(N'2023-07-03' AS Date), CAST(N'2023-07-18' AS Date), N'Стационарное', 5)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (6, 3, 7, N'Отит', CAST(N'2023-08-11' AS Date), CAST(N'2023-08-25' AS Date), N'Амбулаторное', 6)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (7, 10, 6, N'Злокачественные новообразования', CAST(N'2023-09-29' AS Date), CAST(N'2023-10-05' AS Date), N'Стационарное', 7)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (8, 4, 9, N'Сколиоз', CAST(N'2023-11-07' AS Date), CAST(N'2023-11-15' AS Date), N'Амбулаторное', 8)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (9, 6, 8, N'Кариес', CAST(N'2024-01-18' AS Date), CAST(N'2024-01-28' AS Date), N'Стационарное', 9)
INSERT [dbo].[MedicalHistory] ([HistoryID], [PatientID], [DoctorID], [Diagnosis], [DateOfIllness], [DateOfCure], [TreatmentType], [OperationID]) VALUES (10, 8, 10, N'Простатит', CAST(N'2024-02-14' AS Date), CAST(N'2024-02-21' AS Date), N'Амбулаторное', 10)
SET IDENTITY_INSERT [dbo].[MedicalHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Operations] ON 

INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (1, N'Сегментарная резекция', 1, CAST(N'2023-02-28' AS Date), 1, N'Неуспешно', NULL)
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (2, N'Радиочастотная катетерная абляция', 3, CAST(N'2023-03-10' AS Date), 2, N'Успешно', N'OperationsPics/HumanHeart.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (3, N'Трансблефаропластическая резекция корругатора', 2, CAST(N'2023-04-05' AS Date), 5, N'Успешно', N'OperationsPics/HumanBrain.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (4, N'Геморроидэктомия', 5, CAST(N'2023-05-20' AS Date), 7, N'Успешно', NULL)
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (5, N'Дакриоцистэктомия', 4, CAST(N'2023-02-28' AS Date), 9, N'Успешно', N'OperationsPics/HumanEye.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (6, N'Тимпанопластика', 7, CAST(N'2023-02-28' AS Date), 3, N'Неуспешно', N'OperationsPics/HumanEar.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (7, N'Иссечение фрагмента кожи', 6, CAST(N'2023-08-17' AS Date), 10, N'Успешно', NULL)
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (8, N'Коррекция сколиотических деформаций позвоночника', 9, CAST(N'2023-09-12' AS Date), 4, N'Успешно', N'OperationsPics/HumanSpine.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (9, N'Пломбирование', 8, CAST(N'2023-10-25' AS Date), 6, N'Неуспешно', N'OperationsPics/HumanMouth.png')
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (10, N'Простатэктомия', 10, CAST(N'2023-02-28' AS Date), 8, N'Успешно', NULL)
INSERT [dbo].[Operations] ([OperationID], [OperationDescription], [DoctorID], [OperationDate], [PatientID], [OperationResult], [OperationImage]) VALUES (11, N'Удаление зуба', 8, CAST(N'2024-04-12' AS Date), 2, N'Успешно', NULL)
SET IDENTITY_INSERT [dbo].[Operations] OFF
GO
SET IDENTITY_INSERT [dbo].[Patients] ON 

INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (1, N'Иванов', N'Алексей', NULL, N'ул. Центральная, д. 10', N'Москва', N'М', CAST(N'1977-07-17' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (2, N'Петрова', N'Елена', N'Игоревна', N'пр. Ленина, д. 5', N'Санкт-Петербург', N'Ж', CAST(N'1980-04-08' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (3, N'Сидоров', N'Дмитрий', N'Александрович', N'пер. Зеленый, д. 15', N'Екатеринбург', N'М', CAST(N'1994-11-12' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (4, N'Козлова', N'Ольга', N'Владимировна', N'ул. Солнечная, д. 7', N'Новосибирск', N'Ж', CAST(N'1988-09-08' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (5, N'Никитин', N'Игорь', NULL, N'пр. Гагарина, д. 3', N'Казань', N'М', CAST(N'1980-12-12' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (6, N'Антонова', N'Кира', N'Алексеевна', N'проспект Мира, д. 22', N'Волгоград', N'Ж', CAST(N'1977-05-01' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (7, N'Макаров', N'Владислав', N'Павлович', N'ул. Первомайская, д. 11', N'Ростов-на-Дону', N'М', CAST(N'1994-11-05' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (8, N'Григорьева', N'Мария', N'Игоревна', N'ул. Лесная, д. 8', N'Красноярск', N'Ж', CAST(N'1998-01-14' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (9, N'Смирнов', N'Павел', N'Дмитриевич', N'пр. Советский, д. 9', N'Уфа', N'М', CAST(N'1995-11-06' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (10, N'Кузнецова', N'Евгения', N'Васильевна', N'ул. Луговая, д. 14', N'Самара', N'Ж', CAST(N'1985-07-23' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (11, N'Иванов', N'Петр', N'Сергеевич', N'ул. Садовая, д.10', N'Москва', N'М', CAST(N'1978-08-15' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (12, N'Смирнова', N'Елена', N'Игоревна', N'пр. Ленина, д.20', N'Санкт-Петербург', N'Ж', CAST(N'1985-04-25' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (13, N'Козлов', N'Алексей', N'Иванович', N'пл. Победы, д.15', N'Екатеринбург', N'М', CAST(N'1992-11-30' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (14, N'Попова', N'Марина', N'Александровна', N'ул. Центральная, д.7', N'Красноярск', N'Ж', CAST(N'1980-10-10' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (15, N'Зайцев', N'Денис', N'Павлович', N'пр. Ленина, д.45', N'Москва', N'М', CAST(N'1970-03-18' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (16, N'Соколова', N'Ольга', N'Владимировна', N'ул. Пушкина, д.12', N'Санкт-Петербург', N'Ж', CAST(N'1965-07-05' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (17, N'Морозов', N'Артем', N'Игоревич', N'пл. Свободы, д.8', N'Екатеринбург', N'М', CAST(N'1988-01-22' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (18, N'Петрова', N'Анастасия', N'Петровна', N'ул. Мира, д.25', N'Новосибирск', N'Ж', CAST(N'1977-09-12' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (19, N'Кузнецов', N'Игорь', N'Алексеевич', N'пр. Гагарина, д.30', N'Красноярск', N'М', CAST(N'1973-06-28' AS Date))
INSERT [dbo].[Patients] ([PatientID], [PatientSurname], [PatientFirstName], [PatientPatronymic], [Adress], [City], [Gender], [BirthDate]) VALUES (20, N'Васильева', N'Екатерина', N'Сергеевна', N'пл. Ленина, д.3', N'Москва', N'Ж', CAST(N'1982-12-07' AS Date))
SET IDENTITY_INSERT [dbo].[Patients] OFF
GO
SET IDENTITY_INSERT [dbo].[TreatmentSheet] ON 

INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (1, 1, CAST(N'2023-02-20' AS Date), N'Аспирин', CAST(37.1 AS Decimal(3, 1)), N'120/80', N'Удовлетворительное')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (2, 2, CAST(N'2023-03-08' AS Date), N'Ибупрофен', CAST(38.2 AS Decimal(3, 1)), N'130/85', N'Крайне тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (3, 3, CAST(N'2023-04-25' AS Date), N'Амоксициллин', CAST(38.0 AS Decimal(3, 1)), N'125/75', N'Крайне тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (4, 4, CAST(N'2023-06-18' AS Date), N'Энап', CAST(37.8 AS Decimal(3, 1)), N'122/78', N'Тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (5, 5, CAST(N'2023-07-06' AS Date), N'Нурофен', CAST(37.0 AS Decimal(3, 1)), N'118/72', N'Средней тяжести')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (6, 6, CAST(N'2023-08-14' AS Date), N'Цефтриаксон', CAST(38.5 AS Decimal(3, 1)), N'128/82', N'Крайне тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (7, 7, CAST(N'2023-09-30' AS Date), N'Диклофенак', CAST(37.3 AS Decimal(3, 1)), N'124/80', N'Средней тяжести')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (8, 8, CAST(N'2023-11-10' AS Date), N'Аспикор', CAST(37.9 AS Decimal(3, 1)), N'126/79', N'Тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (9, 9, CAST(N'2024-01-22' AS Date), N'Левомицетин', CAST(38.7 AS Decimal(3, 1)), N'132/85', N'Крайне тяжелое')
INSERT [dbo].[TreatmentSheet] ([TreatmentID], [HistoryID], [DateOfTreatment], [Medicines], [Temperature], [Pressure], [PatientsCondition]) VALUES (10, 10, CAST(N'2024-02-17' AS Date), N'Парацетамол', CAST(37.2 AS Decimal(3, 1)), N'120/76', N'Удовлетворительное')
SET IDENTITY_INSERT [dbo].[TreatmentSheet] OFF
GO
ALTER TABLE [dbo].[MedicalHistory]  WITH CHECK ADD  CONSTRAINT [FK_MedicalHistory_Doctors] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctors] ([DoctorID])
GO
ALTER TABLE [dbo].[MedicalHistory] CHECK CONSTRAINT [FK_MedicalHistory_Doctors]
GO
ALTER TABLE [dbo].[MedicalHistory]  WITH CHECK ADD  CONSTRAINT [FK_MedicalHistory_Operations] FOREIGN KEY([OperationID])
REFERENCES [dbo].[Operations] ([OperationID])
GO
ALTER TABLE [dbo].[MedicalHistory] CHECK CONSTRAINT [FK_MedicalHistory_Operations]
GO
ALTER TABLE [dbo].[MedicalHistory]  WITH CHECK ADD  CONSTRAINT [FK_MedicalHistory_Patients] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patients] ([PatientID])
GO
ALTER TABLE [dbo].[MedicalHistory] CHECK CONSTRAINT [FK_MedicalHistory_Patients]
GO
ALTER TABLE [dbo].[Operations]  WITH CHECK ADD  CONSTRAINT [FK_Operations_Doctors] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctors] ([DoctorID])
GO
ALTER TABLE [dbo].[Operations] CHECK CONSTRAINT [FK_Operations_Doctors]
GO
ALTER TABLE [dbo].[Operations]  WITH CHECK ADD  CONSTRAINT [FK_Operations_Patients] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patients] ([PatientID])
GO
ALTER TABLE [dbo].[Operations] CHECK CONSTRAINT [FK_Operations_Patients]
GO
ALTER TABLE [dbo].[TreatmentSheet]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentSheet_MedicalHistory] FOREIGN KEY([HistoryID])
REFERENCES [dbo].[MedicalHistory] ([HistoryID])
GO
ALTER TABLE [dbo].[TreatmentSheet] CHECK CONSTRAINT [FK_TreatmentSheet_MedicalHistory]
GO
ALTER TABLE [dbo].[MedicalHistory]  WITH CHECK ADD  CONSTRAINT [Огриничение_видов] CHECK  (([TreatmentType]='Стационарное' OR [TreatmentType]='Амбулаторное'))
GO
ALTER TABLE [dbo].[MedicalHistory] CHECK CONSTRAINT [Огриничение_видов]
GO
ALTER TABLE [dbo].[Operations]  WITH CHECK ADD  CONSTRAINT [Результат] CHECK  (([OperationResult]='Успешно' OR [OperationResult]='Неуспешно'))
GO
ALTER TABLE [dbo].[Operations] CHECK CONSTRAINT [Результат]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD  CONSTRAINT [Ограничение_Genderа] CHECK  (([Gender]='Ж' OR [Gender]='М'))
GO
ALTER TABLE [dbo].[Patients] CHECK CONSTRAINT [Ограничение_Genderа]
GO
ALTER TABLE [dbo].[Patients_test]  WITH CHECK ADD  CONSTRAINT [Ограничение_Genderа2] CHECK  (([Gender]='Ж' OR [Gender]='М'))
GO
ALTER TABLE [dbo].[Patients_test] CHECK CONSTRAINT [Ограничение_Genderа2]
GO
ALTER TABLE [dbo].[TreatmentSheet]  WITH CHECK ADD  CONSTRAINT [Genderожительная Temperature] CHECK  (([Temperature]>=(26.5) AND [Temperature]<=(42)))
GO
ALTER TABLE [dbo].[TreatmentSheet] CHECK CONSTRAINT [Genderожительная Temperature]
GO
/****** Object:  StoredProcedure [dbo].[GetMalePatientsByTypeOfTreatment]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMalePatientsByTypeOfTreatment] (@TypeOfTreatment NVARCHAR(75)) AS
BEGIN
	SELECT
		CONCAT(Surname, ' ', FirstName, ' ', Patronymic) AS ФИО_Пациента,
		Gender,
		Age,
		DateOfIllness,
		DateOfCure,
		TreatmentType
	FROM 
		Patients, MedicalHistory
	WHERE
		Patients.PatientID = MedicalHistory.PatientID AND Gender = 'М' AND TreatmentType = @TypeOfTreatment;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetPatientInfo]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPatientInfo] AS
BEGIN
	SELECT
		Surname,
		FirstName,
		Patronymic,
		Diagnosis,
		Medicines,
		Pressure,
		Temperature,
		PatientsCondition
	FROM
		Patients, MedicalHistory, TreatmentSheet
	WHERE
		MedicalHistory.HistoryID = TreatmentSheet.HistoryID AND Patients.PatientID = MedicalHistory.PatientID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetPatientStatus]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPatientStatus]
	@PatientStatus nvarchar(50),
    @PatientCount INT OUTPUT
AS
BEGIN
    SELECT @PatientCount = COUNT(*)
    FROM Patients, MedicalHistory, TreatmentSheet
    WHERE Patients.PatientID = MedicalHistory.PatientID 
	AND TreatmentSheet.HistoryID = MedicalHistory.HistoryID AND PatientsCondition = @PatientStatus
	IF @PatientCount > 0 
		RETURN @PatientCount
	ELSE
		RETURN 0
END;
GO
/****** Object:  StoredProcedure [dbo].[GetPatientsTemperatureInfo]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPatientsTemperatureInfo]
	@Temperature DECIMAL(3, 1),
    @PatientCount INT OUTPUT
AS
BEGIN
    SELECT @PatientCount = COUNT(*)
    FROM Patients, MedicalHistory, TreatmentSheet
    WHERE Patients.PatientID = MedicalHistory.PatientID 
	AND TreatmentSheet.HistoryID = MedicalHistory.HistoryID AND Temperature = @Temperature;
END;
GO
/****** Object:  StoredProcedure [dbo].[MalePatientsCount]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MalePatientsCount] AS 
SELECT COUNT(Gender) AS 'Кол-во заболевших мужчин'
FROM Patients
WHERE Gender ='М'
GO
/****** Object:  StoredProcedure [dbo].[UpdateDoctorStatus]    Script Date: 09.11.2024 19:38:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDoctorStatus]
	@DoctorLastName nvarchar(20),
    @DoctorFirstName nvarchar(20),
	@DoctorPatronymic nvarchar(20),
	@NewScientificTitle nvarchar(50)
AS
BEGIN
	UPDATE Doctors
	SET ScientificTitle = @NewScientificTitle
	WHERE Surname = @DoctorLastName AND FirstName = @DoctorFirstName AND Patronymic = @DoctorPatronymic;
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[26] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FirstView"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 187
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MedicalHistory"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 205
               Right = 444
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Patients"
            Begin Extent = 
               Top = 6
               Left = 482
               Bottom = 219
               Right = 663
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1530
         Width = 1800
         Width = 1365
         Width = 1845
         Width = 3210
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1905
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FourthView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FourthView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Doctors"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ThirdView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ThirdView'
GO
USE [master]
GO
ALTER DATABASE [Hospital] SET  READ_WRITE 
GO
