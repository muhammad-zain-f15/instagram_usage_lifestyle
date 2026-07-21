-- usage:  EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		PRINT '======================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '======================================';
		PRINT '>> Truncating table: instagram_usage';
		TRUNCATE TABLE bronze.instagram_usage
		PRINT '>> Inserting Data into bronze.instagram_usage'
		BULK INSERT bronze.instagram_usage
		FROM 'E:/Data Analysis learning/sql/instagram_usage_lifestyle.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			CODEPAGE = '65001',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '======================================';
		PRINT 'Error occured during loading bronze layer'
		PRINT 'Error message =' + ERROR_MESSAGE();
		PRINT 'Error number = ' + CAST(ERROR_NUMBER() AS NVARCHAR); 
		PRINT '======================================';
	END CATCH
END
SELECT * FROM bronze.instagram_usage;
