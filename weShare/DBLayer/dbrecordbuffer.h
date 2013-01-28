#ifndef RECORDBUFFER_H
#define RECORDBUFFER_H

#include "dbfield.h"
#include <vector>

class DbRecordBuffer
{
public:
    DbRecordBuffer();
    ~DbRecordBuffer();

    void setKey(int k) { m_key = k;}
    int getKey() const {return m_key;}

    DbField* getField(int i) const {return m_fields.at(i);}
    void addField(DbField* f) { m_fields.push_back(f);}
    int count() const {return m_fields.size();}

private:
    std::vector<DbField*> m_fields;

    int m_key;

};

#endif // RECORDBUFFER_H
