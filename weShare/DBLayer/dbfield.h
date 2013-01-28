#ifndef RECORDFIELD_H
#define RECORDFIELD_H

#include <string>

class DbField
{
public:
    DbField();

    std::string name() const {return m_Name;}
    void name(const std::string& n){ m_Name = n;}

    std::string type() const {return m_Type;}
    void type(const std::string& n){ m_Type = n;}

    std::string value() const {return m_Value;}
    void value(const std::string& n){ m_Value = n;}

    std::string length() const {return m_Length;}
    void length(const std::string& n){ m_Length = n;}


private:
    std::string m_Name;
    std::string m_Value;
    std::string m_Type;
    std::string m_Length;
};

#endif // RECORDFIELD_H
