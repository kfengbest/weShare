#include "connectionsqlite.h"

#include "sqlite3.h"
#include "dbrecordbuffer.h"
#include "dbfield.h"
#include <sstream>

ConnectionSqlite::ConnectionSqlite()
{
//    std::string path("/Users/fengka/Src/GenericDB/DBScript/Compass.db");
//    ConnectToDatabase(path);
}

ConnectionSqlite::~ConnectionSqlite()
{
    CloseDatabase();
}

 ConnectionSqlite* ConnectionSqlite::get()
 {
    static ConnectionSqlite theOnlyOne;
    return &theOnlyOne;
 }


bool ConnectionSqlite::ConnectToDatabase(const std::string& path)
{
    int result = sqlite3_open(path.c_str(), &mpDatabase);
    if (result == SQLITE_OK)
        return true;

    sqlite3_close(mpDatabase);
    mpDatabase = NULL;
    return false;
}

void ConnectionSqlite::CloseDatabase()
{
    if (mpDatabase != NULL)
    {
        sqlite3_close(mpDatabase);
        mpDatabase = NULL;
    }
}

// insert, delete, update.
bool ConnectionSqlite::ExecuteSql(const std::string& sql)
{
    if (mpDatabase == NULL || sql.empty())
        return false;

    int len = -1;
    bool bRet = true;
    sqlite3_stmt* pStmt = NULL;
    const char* pTail = NULL;
    int rc = sqlite3_prepare(mpDatabase, sql.c_str(), len, &pStmt, &pTail);
    if (rc == SQLITE_OK)
    {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_DONE)
            bRet = true;
        else
            bRet = false;
    }
    else
        bRet = false;

    sqlite3_finalize(pStmt);

    return bRet;
}

bool ConnectionSqlite::ExecuteSql(const std::string& sql, std::vector<DbRecordBuffer*>& results)
{
    if (mpDatabase == NULL || sql.empty())
        return false;

    int len = -1;
    bool bRet = true;
    sqlite3_stmt* pStmt = NULL;
    const char* pTail = NULL;
    int rc = sqlite3_prepare(mpDatabase, sql.c_str(), len, &pStmt, &pTail);
    if (rc == SQLITE_OK)
    {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_DONE)
            bRet = true;

        while (rc == SQLITE_ROW)
        {
            DbRecordBuffer* pRecordBuffer = new DbRecordBuffer;
            results.push_back(pRecordBuffer);
            buildRowRecord(pStmt, pRecordBuffer);

            rc = sqlite3_step(pStmt);
        }
    }
    else
        bRet = false;

    sqlite3_finalize(pStmt);

    return bRet;
}

// select * from xxx where 1=0;
bool ConnectionSqlite::buildRecordBufferTypes(const std::string& sql, DbRecordBuffer* pRecordBuffer)
{
    if (mpDatabase == NULL || sql.empty())
        return false;

    int len = -1;
    bool bRet = true;
    sqlite3_stmt* pStmt = NULL;
    const char* pTail = NULL;
    int rc = sqlite3_prepare(mpDatabase, sql.c_str(), len, &pStmt, &pTail);
    if (rc == SQLITE_OK)
    {
        rc = sqlite3_step(pStmt);
        bRet = true;

        buildRowRecord(pStmt, pRecordBuffer);

        bRet = true;
    }
    else
        bRet = false;

    sqlite3_finalize(pStmt);

    return bRet;
}

void ConnectionSqlite::buildRowRecord(sqlite3_stmt* pStmt, DbRecordBuffer* pRecordBuffer)
{
    int count = sqlite3_column_count(pStmt);
    for(int i = 0; i < count; i++)
    {
        std::string colName = std::string(sqlite3_column_name(pStmt, i));
        std::string colType = std::string(sqlite3_column_decltype(pStmt, i));
        int n = sqlite3_column_bytes(pStmt, i);

        const void* txt = sqlite3_column_blob(pStmt, i);
        std::string colValue =  std::string(static_cast<const char*>(txt), n);

     //   qDebug() << "Column Num:" << count << " Name: " << QString::fromStdString(colName) << " Type " << QString::fromStdString(colType) << " value: " << QString::fromStdString(colValue);

        DbField* dbf = new DbField();
        dbf->name(colName);
        dbf->type(colType);
        dbf->value(colValue);
        pRecordBuffer->addField(dbf);

        // TODO: this is hard coded.
        if(colName == "AIMKEY" && i == 0)
        {
            std::stringstream ss(colValue);
            int iv;
            ss >> iv;
            pRecordBuffer->setKey(iv);
        }

    }
}
