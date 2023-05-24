USE [W_test]
GO

/****** Object:  Table [dbo].[Logs]    Script Date: 24.05.2023 11:32:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Logs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [varchar](100) NOT NULL,
	[ExecutionDateTime] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


