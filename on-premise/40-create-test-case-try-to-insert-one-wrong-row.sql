-------------------------------------------------------------------------
-- Event:      SQL Start 2024 - June 14                                --
--             https://www.sqlstart.it/                                --
--                                                                     --
-- Session:    SQL Server unit testing with tSQLt, Docker and          --
--             GitHub Actions                                          --
--                                                                     --
-- Demo:       Test case: Try to insert one wrong row                  --
-- Author:     Sergio Govoni                                           --
-- Notes:      --                                                      --
-------------------------------------------------------------------------

USE [AdventureWorks2022];
GO


CREATE OR ALTER PROCEDURE UnitTestTRProductSafetyStockLevel.[test try to insert one wrong row]
AS
BEGIN
  /*
    Arrange:
    Spy the procedure Production.usp_Raiserror_SafetyStockLevel
  */
  EXEC tSQLt.SpyProcedure 'Production.usp_Raiserror_SafetyStockLevel';

  /*
    Act:
    Try to insert one wrong rows with SafetyStockLevel lower than 10
  */
  INSERT INTO Production.Product
  (
    [Name]
    ,ProductNumber
    ,MakeFlag
    ,FinishedGoodsFlag
    ,SafetyStockLevel
    ,ReorderPoint
    ,StandardCost
    ,ListPrice
    ,DaysToManufacture
    ,SellStartDate
    ,rowguid
    ,ModifiedDate
  )
  VALUES
  (
    N'Carbon Bar 1'
    ,N'CB-0001'
    ,0
    ,0
    ,9 /* SafetyStockLevel */
    ,750
    ,0.0000
    ,78.0000
    ,0
    ,GETDATE()
    ,NEWID()
    ,GETDATE()
  );

  /*
    Assert
  */
  IF NOT EXISTS (SELECT _id_ FROM Production.usp_Raiserror_SafetyStockLevel_SpyProcedureLog)
    EXEC tSQLt.Fail
      @Message0 = 'Production.usp_Raiserror_SafetyStockLevel_SpyProcedureLog is empty! usp_Raiserror_SafetyStockLevel has not been called!';
END;


/*
EXEC tSQLt.Run 'UnitTestTRProductSafetyStockLevel.[test try to insert one wrong row]';
GO
*/