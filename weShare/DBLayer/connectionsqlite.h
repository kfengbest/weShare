#ifndef CONNECTIONSQLITE_H
#define CONNECTIONSQLITE_H

#include <string>
#include <vector>

struct sqlite3;
struct sqlite3_stmt;
class DatabaseQueryExecutor;
class DbRecordBuffer;

class ConnectionSqlite
{
public:
    ConnectionSqlite();
    ~ConnectionSqlite();

    static ConnectionSqlite* get();

    bool ExecuteSql(const std::string& sql);
    bool ExecuteSql(const std::string& sql, std::vector<DbRecordBuffer*>& results);

    bool buildRecordBufferTypes(const std::string& sql, DbRecordBuffer* pRecordBuffer);

    bool ConnectToDatabase(const std::string& path);
    void CloseDatabase();

private:
    sqlite3* mpDatabase;

    void buildRowRecord(sqlite3_stmt* pStmt, DbRecordBuffer* pRecordBuffer);
};


#endif // CONNECTIONSQLITE_H
