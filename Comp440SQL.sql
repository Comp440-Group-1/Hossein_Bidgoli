USE [s16guest15]
GO
/****** Object:  User [s16guest15]    Script Date: 5/10/2016 12:59:40 PM ******/
CREATE USER [s16guest15] FOR LOGIN [s16guest15] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [s16guest15]
GO
/****** Object:  StoredProcedure [dbo].[usp_AddProduct]    Script Date: 5/10/2016 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AddProduct]
(
  @Name nvarchar(50),
  @Description nvarchar(50)
)
AS
begin
begin try
insert into Product ([Product Name],[Description])
values (@Name, @Description)
end  try

begin catch
print 'Product could not be created'
end catch
END

GO
/****** Object:  StoredProcedure [dbo].[usp_FeatureCount]    Script Date: 5/10/2016 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[NewFeatureCount]
(
  @id int 
)
AS
Begin
 declare @NewFeatureRelease float
 declare @totalSum  int
 declare @VersionNum nchar(20)

 set  @NewFeatureRelease = (select [ReleaseID] from Release
 where [Release Type] = 'new features release') 
 
 begin try


      set @VersionNum = (select [VersionNum] from Versions 
                     where [Version ID] = @VersionID)

	  set @totalSum = (select count([Feature ID]) 
               from [dbo].[Versions_FeatureID_Releases] 
			   where [ReleaseID] = @NewFeatureReleaseID AND
			         [VersionID] = @VersionID )

	     if @sum >0 
    
            print 'Feature number = ' + (convert(varchar(8), @sum)) + ' release ' 
	        + @VersionNum 
   
        else print 'There are not any new features, just bug fixes.'

end  try

 begin catch
  
  DECLARE
   @ErrorMessage NVARCHAR(2048),
   @ErrorSeverity INT,
   @ErrorState INT
 
 SELECT
   @ErrorMessage = ERROR_MESSAGE(),
   @ErrorSeverity = ERROR_SEVERITY(),
   @ErrorState = ERROR_STATE()
 
 RAISERROR (@ErMessage,
             @ErSeverity,
             @ErState )


end catch

END

GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateProductVersionByID]    Script Date: 5/10/2016 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_UpdateProductVersionByID]
(
@ProductName nvarchar(20),
@ProductID int,
@VersionID int,
@VersionNum nchar(10)

)
AS
Begin
select @ProductID = [ProductID] from Products where [ProductName] = @ProductName
select @VersionID = [VersionID] from Versions_Products where [ProductID] = @ProductID
 
update Versions 
set [VersionNum] = @VersionNum  where [VersionID] = @VersionID 

END;

GO
/****** Object:  StoredProcedure [dbo].[usp_RequestCount]    Script Date: 5/10/2016 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_RequestCount] 

 AS  
 begin
    begin TRY
    select  Products.[ProductName], Versions.[Version Num],  month(Requests.[Date]) , count(Requests.[Customer ID])
    from Requests, Products, Versions 
	group by [Product Name], [VersionNum], [Date] 
    Order by [Date] , count([CustomerID]) 
    end TRY

  begin catch

  print 'There was an Error'
  end catch

end 
