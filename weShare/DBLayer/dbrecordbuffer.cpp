#include "dbrecordbuffer.h"
#include "dbfield.h"

DbRecordBuffer::DbRecordBuffer()
{
}

DbRecordBuffer::~DbRecordBuffer()
{
    for(int i = 0; i < m_fields.size(); i++)
    {
        DbField* pField = m_fields.at(i);
        delete pField;
        pField = NULL;
    }

    m_fields.clear();
}
