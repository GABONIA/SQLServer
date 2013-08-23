/****** Object:  Table [dbo].[AddedStockTable]    Script Date: 8/23/2013 8:22:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AddedStockTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StockSymbol] [varchar](10) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[MainStockTable]    Script Date: 8/23/2013 8:22:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MainStockTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StockSymbol] [varchar](10) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
